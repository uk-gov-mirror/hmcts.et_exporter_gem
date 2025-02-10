json.(response, :reference, :agree_with_claimant_notice, :agree_with_claimant_pension_benefits, :agree_with_claimants_description_of_job_or_title, :agree_with_claimants_hours, :agree_with_early_conciliation_details, :agree_with_earnings_details, :agree_with_employment_dates, :case_number, :claim_information, :claimants_name, :continued_employment, :date_of_receipt, :defend_claim, :defend_claim_facts, :disagree_claimant_notice_reason, :disagree_claimant_pension_benefits_reason, :disagree_claimants_job_or_title, :disagree_conciliation_reason, :disagree_employment, :email_receipt, :employment_end, :employment_start, :make_employer_contract_claim, :queried_pay_before_tax_period, :queried_take_home_pay_period)
json.(response, :case_heard_by_preference, :case_heard_by_preference_reason)
json.queried_hours response.queried_hours.to_f
json.queried_pay_before_tax response.queried_pay_before_tax.to_f
json.queried_take_home_pay response.queried_take_home_pay.to_f
json.respondent do
  json.partial! "et_exporter/v1/respondent", respondent: response.respondent, formats: [:json]
end
if response.representative.present?
  json.representative do
    json.partial! "et_exporter/v1/representative", representative: response.representative, formats: [:json]
  end
else
  json.representative nil
end
json.uploaded_files do
  json.partial! "et_exporter/v1/uploaded_file", collection: response.uploaded_files, as: :uploaded_file, formats: [:json]
end
