require 'sidekiq'
module EtExporter
  class ClaimFilesAddedHandler
    def handle(export, export_external_data, files, event_service: Rails.application.event_service, use_active_job: Rails.application.config.try(:use_active_job))
      if use_active_job
        handle_active_job(export, export_external_data, files)
      else
        handle_sidekiq(event_service, export, export_external_data, files)
      end
    end
    
    def client_push(item)
      Sidekiq::Client.new(Sidekiq.redis_pool).push(item)
    end

    private

    def handle_sidekiq(event_service, export, export_external_data, files)
      json = EtExporter::ApplicationController.render('et_exporter/v1/update_claim/files_added', locals: { files: files, export: export, system: export.external_system, export_external_data: export_external_data }, formats: [:json])
      jid = client_push('class' => '::EtExporter::ExportClaimUpdateWorker', 'args' => [json], 'queue' => export.external_system.export_queue)
      event_data = {
        sidekiq: {
          jid: jid,
          bid: nil
        },
        export_id: export.id,
        external_data: export_external_data,
        state: 'queued',
        percent_complete: 0,
        message: 'Queued for export from API'
      }
      event_service.publish('ClaimExportFeedbackReceived', event_data.to_json)
    end

    def handle_active_job(export, export_external_data, files)
      json = EtExporter::ApplicationController.render('et_exporter/v1/update_claim/files_added', locals: { files: files, export: export, system: export.external_system, export_external_data: export_external_data }, formats: [:json])
      jid = EtExporter::ExportClaimUpdateJob.set(queue: export.external_system.export_queue).perform_later(json)
      event_data = {
        sidekiq: {
          jid: jid,
          bid: nil
        },
        export_id: export.id,
        external_data: export_external_data,
        state: 'queued',
        percent_complete: 0,
      }
      event_service.publish('ClaimExportFeedbackReceived', event_data.to_json)
    end
  end
end
