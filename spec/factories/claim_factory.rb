FactoryBot.define do
  factory :claim do
    transient do
      number_of_claimants { 1 }
      number_of_respondents { 1 }
      has_representative { true }
      secondary_claimant_traits { [:default] }
    end

    secondary_respondents { [] }
    secondary_claimants { [] }

    sequence :reference do |n|
      "#{office_code}#{20000000 + n}00"
    end

    sequence :submission_reference do |n|
      "J704-ZK5E#{n}"
    end

    submission_channel { 'Web' }
    case_type { 'Single' }
    jurisdiction { 2 }

    trait :default do
      with_pdf_file
      with_rtf_file
      with_claimants_csv_file
      with_employment_details_still_working
      office_code { 22 }
      date_of_receipt { Time.zone.now }
      pdf_template_reference { "et1-v1-en" }
      other_outcome { "other outcome" }
      reference { "222000000300" }
      number_of_claimants { 1 }
      number_of_respondents { 1 }
      case_heard_by_preference { 'judge' }
      case_heard_by_preference_reason { "I feel intimidated by a panel" }
    end


    after(:build) do |claim, evaluator|
      claim.primary_claimant = build(:claimant, :default) if claim.primary_claimant.blank? && evaluator.number_of_claimants > 0
      claim.primary_respondent = build(:respondent, :default) if claim.primary_respondent.blank? && evaluator.number_of_respondents > 0
      claim.secondary_claimants.concat build_list(:claimant, [evaluator.number_of_claimants - 1, 0].max, *evaluator.secondary_claimant_traits)
      claim.secondary_respondents.concat build_list(:respondent, [evaluator.number_of_respondents - 1, 0].max, :default)
      claim.claimant_count += evaluator.number_of_claimants
      claim.primary_representative = build(:representative, :default) if claim.primary_representative.blank? && evaluator.has_representative
    end

    trait :with_pdf_file do
      after(:build) do |claim, _evaluator|
        claim.uploaded_files << build(:uploaded_file, :example_pdf, :system_file_scope)
      end
    end

    trait :with_acas_pdf_file do
      after(:build) do |claim, _evaluator|
        claim.uploaded_files << build(:uploaded_file, :example_acas_pdf, :system_file_scope)
      end
    end

    trait :with_rtf_file do
      after(:build) do |claim, _evaluator|
        claim.uploaded_files << build(:uploaded_file, :example_claim_rtf, :system_file_scope)
      end
    end

    trait :with_claimants_csv_file do
      after(:build) do |claim, _evaluator|
        claim.uploaded_files << build(:uploaded_file, :example_claim_claimants_csv, :system_file_scope)
      end
    end

    trait :with_employment_details_still_working do
      employment_details do
        {
          "start_date": "2009-11-18",
          "end_date": nil,
          "notice_period_end_date": nil,
          "job_title": "agriculturist",
          "average_hours_worked_per_week": 38.0,
          "gross_pay": 3000,
          "gross_pay_period_type": "monthly",
          "net_pay": 2000,
          "net_pay_period_type": "monthly",
          "worked_notice_period_or_paid_in_lieu": nil,
          "notice_pay_period_type": nil,
          "notice_pay_period_count": nil,
          "enrolled_in_pension_scheme": true,
          "benefit_details": "Company car, private health care",
          "found_new_job": nil,
          "new_job_start_date": nil,
          "new_job_gross_pay": nil
        }.stringify_keys
      end
    end

    trait :with_employment_details_terminated do
      employment_details do
        {
          "start_date": "2009-11-18",
          "end_date": "2019-01-01",
          "notice_period_end_date": nil,
          "job_title": "agriculturist",
          "average_hours_worked_per_week": 38.0,
          "gross_pay": 3000,
          "gross_pay_period_type": "monthly",
          "net_pay": 2000,
          "net_pay_period_type": "monthly",
          "worked_notice_period_or_paid_in_lieu": true,
          "notice_pay_period_type": 'weeks',
          "notice_pay_period_count": 3.0,
          "enrolled_in_pension_scheme": true,
          "benefit_details": "Company car, private health care",
          "found_new_job": true,
          "new_job_start_date": "2009-11-18",
          "new_job_gross_pay": 3000
        }.stringify_keys
      end
    end

    trait :with_employment_details_notice_period do
      employment_details do
        {
          "start_date": "2009-11-18",
          "end_date": nil,
          "notice_period_end_date": "2025-01-01",
          "job_title": "agriculturist",
          "average_hours_worked_per_week": 38.0,
          "gross_pay": 3000,
          "gross_pay_period_type": "monthly",
          "net_pay": 2000,
          "net_pay_period_type": "monthly",
          "worked_notice_period_or_paid_in_lieu": nil,
          "notice_pay_period_type": nil,
          "notice_pay_period_count": nil,
          "enrolled_in_pension_scheme": true,
          "benefit_details": "Company car, private health care",
          "found_new_job": nil,
          "new_job_start_date": nil,
          "new_job_gross_pay": nil
        }.stringify_keys
      end
    end

    trait :without_employment_details do
      employment_details do
        {}
      end
    end
  end
end
