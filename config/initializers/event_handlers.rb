Rails.application.config.after_initialize do |app|
  app.event_service.subscribe('ClaimQueuedForExport', EtExporter::ClaimQueuedHandler, async: false, in_process: true)
  app.event_service.subscribe('ResponseQueuedForExport', EtExporter::ResponseQueuedHandler, async: false, in_process: true)
  app.event_service.subscribe('ClaimExportFeedbackReceived', EtExporter::ClaimExportFeedbackReceivedHandler, async: true, in_process: false)
  app.event_service.subscribe('ResponseExportFeedbackReceived', EtExporter::ClaimExportFeedbackReceivedHandler, async: true, in_process: false)
  app.event_service.subscribe('ExportedClaimFilesAdded', EtExporter::ClaimFilesAddedHandler, async: false, in_process: true)
end
