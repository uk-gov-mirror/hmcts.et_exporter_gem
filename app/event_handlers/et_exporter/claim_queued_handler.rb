require 'sidekiq'
module EtExporter
  class ClaimQueuedHandler
    def handle(export, event_service: Rails.application.event_service, use_active_job: Rails.application.config.try(:use_active_job))
      if use_active_job
        handle_active_job(export, event_service: event_service)
      else
        handle_sidekiq(export, event_service: event_service)
      end
    end
    
    def client_push(item)
      Sidekiq::Client.new(Sidekiq.redis_pool).push(item)
    end

    def handle_sidekiq(export, event_service:)
      json = EtExporter::ApplicationController.render('et_exporter/v1/export_claim/export', locals: {claim: export.resource, export: export, system: export.external_system}, formats: [:json])
      jid = client_push('class' => '::EtExporter::ExportClaimWorker', 'args' => [json], 'queue' => export.external_system.export_queue)
      event_data = {
        sidekiq: {
          jid: jid,
          bid: nil,
        },
        export_id: export.id,
        external_data: {},
        state: 'queued',
        percent_complete: 0,
        message: 'Queued for export from API'
      }
      event_service.publish('ClaimExportFeedbackReceived', event_data.to_json)
    end

    def handle_active_job(export, event_service:)
      json = EtExporter::ApplicationController.render('et_exporter/v1/export_claim/export', locals: {claim: export.resource, export: export, system: export.external_system}, formats: [:json])
      jid = EtExporter::ExportClaimJob.set(queue: export.external_system.export_queue).perform_later(json)
      event_data = {
        sidekiq: {
          jid: jid,
          bid: nil,
        },
        export_id: export.id,
        external_data: {},
        state: 'queued',
        percent_complete: 0,
        message: 'Queued for export from API'
      }
      event_service.publish('ClaimExportFeedbackReceived', event_data.to_json)
    end
  end
end
