require 'sidekiq'
module EtExporter
  class ResponseQueuedHandler
    def handle(export, use_active_job: Rails.application.config.try(:use_active_job))
      if use_active_job
        handle_active_job(export)
      else
        handle_sidekiq(export)
      end
    end
    
    def client_push(item)
      Sidekiq::Client.new(Sidekiq.redis_pool).push(item)
    end

    private

    def handle_sidekiq(export)
      json = EtExporter::ApplicationController.render('et_exporter/v1/export_response/export', locals: { response: export.resource, export: export, system: export.external_system }, formats: [:json])
      client_push('class' => '::EtExporter::ExportResponseWorker', 'args' => [json], 'queue' => export.external_system.export_queue)
    end

    def handle_active_job(export)
      json = EtExporter::ApplicationController.render('et_exporter/v1/export_response/export', locals: { response: export.resource, export: export, system: export.external_system }, formats: [:json])
      EtExporter::ExportResponseJob.set(queue: export.external_system.export_queue).perform_later(json)
    end
  end
end
