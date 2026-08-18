json.(claim, :reference, :case_type, :claim_details, :claimant_count, :date_of_receipt)
json.(claim, :desired_outcomes, :discrimination_claims, :is_unfair_dismissal, :jurisdiction, :miscellaneous_information)
json.(claim, :is_unfair_dismissal, :office_code, :other_claim_details, :other_known_claimant_names, :other_outcome)
json.(claim, :pay_claims, :send_claim_to_whistleblowing_entity, :submission_channel, :submission_reference)
json.(claim, :case_heard_by_preference, :case_heard_by_preference_reason) if claim.respond_to? :case_heard_by_preference_reason
json.(claim, :last_event_date) if claim.respond_to? :last_event_date
if claim.employment_details.present?
  json.employment_details do
    json.partial! "et_exporter/v1/employment_details", employment: claim.employment_details, formats: [:json]
  end
else
  json.employment_details({})
end
json.primary_claimant do
  json.partial! "et_exporter/v1/primary_claimant", claimant: claim.primary_claimant, formats: [:json]
end
json.secondary_claimants do
  json.partial! "et_exporter/v1/claimant", collection: claim.secondary_claimants, as: :claimant, formats: [:json]
end
json.primary_respondent do
  json.partial! "et_exporter/v1/respondent", respondent: claim.primary_respondent, formats: [:json]
end
json.secondary_respondents do
  json.partial! "et_exporter/v1/respondent", collection: claim.secondary_respondents, as: :respondent, formats: [:json]
end
if claim.primary_representative.present?
  json.primary_representative do
    json.partial! "et_exporter/v1/representative", representative: claim.primary_representative, formats: [:json]
  end
else
  json.primary_representative nil
end
json.uploaded_files do
  json.partial! "et_exporter/v1/uploaded_file", collection: claim.uploaded_files.system_file_scope, as: :uploaded_file, formats: [:json]
end
