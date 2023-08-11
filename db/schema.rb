# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2019_03_01_204850) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "baseline_counts", force: :cascade do |t|
    t.string "nct_id"
    t.integer "result_group_id"
    t.string "ctgov_group_code"
    t.string "units"
    t.string "scope"
    t.integer "count"
  end

  create_table "baseline_measurements", force: :cascade do |t|
    t.string "nct_id"
    t.integer "result_group_id"
    t.string "ctgov_group_code"
    t.string "classification"
    t.string "category"
    t.string "title"
    t.text "description"
    t.string "units"
    t.string "param_type"
    t.string "param_value"
    t.decimal "param_value_num"
    t.string "dispersion_type"
    t.string "dispersion_value"
    t.decimal "dispersion_value_num"
    t.decimal "dispersion_lower_limit"
    t.decimal "dispersion_upper_limit"
    t.string "explanation_of_na"
    t.index ["category"], name: "index_ctgov.baseline_measurements_on_category"
    t.index ["classification"], name: "index_ctgov.baseline_measurements_on_classification"
    t.index ["dispersion_type"], name: "index_ctgov.baseline_measurements_on_dispersion_type"
    t.index ["param_type"], name: "index_ctgov.baseline_measurements_on_param_type"
  end

  create_table "brief_summaries", force: :cascade do |t|
    t.string "nct_id"
    t.text "description"
  end

  create_table "browse_conditions", force: :cascade do |t|
    t.string "nct_id"
    t.string "mesh_term"
    t.string "downcase_mesh_term"
    t.index ["downcase_mesh_term"], name: "index_ctgov.browse_conditions_on_downcase_mesh_term"
    t.index ["mesh_term"], name: "index_ctgov.browse_conditions_on_mesh_term"
    t.index ["nct_id"], name: "index_ctgov.browse_conditions_on_nct_id"
  end

  create_table "browse_interventions", force: :cascade do |t|
    t.string "nct_id"
    t.string "mesh_term"
    t.string "downcase_mesh_term"
    t.index ["downcase_mesh_term"], name: "index_ctgov.browse_interventions_on_downcase_mesh_term"
    t.index ["mesh_term"], name: "index_ctgov.browse_interventions_on_mesh_term"
    t.index ["nct_id"], name: "index_ctgov.browse_interventions_on_nct_id"
  end

  create_table "calculated_values", force: :cascade do |t|
    t.string "nct_id"
    t.integer "number_of_facilities"
    t.integer "number_of_nsae_subjects"
    t.integer "number_of_sae_subjects"
    t.integer "registered_in_calendar_year"
    t.date "nlm_download_date"
    t.integer "actual_duration"
    t.boolean "were_results_reported", default: false
    t.integer "months_to_report_results"
    t.boolean "has_us_facility"
    t.boolean "has_single_facility", default: false
    t.integer "minimum_age_num"
    t.integer "maximum_age_num"
    t.string "minimum_age_unit"
    t.string "maximum_age_unit"
    t.integer "number_of_primary_outcomes_to_measure"
    t.integer "number_of_secondary_outcomes_to_measure"
    t.integer "number_of_other_outcomes_to_measure"
    t.index ["actual_duration"], name: "index_ctgov.calculated_values_on_actual_duration"
    t.index ["months_to_report_results"], name: "index_ctgov.calculated_values_on_months_to_report_results"
    t.index ["number_of_facilities"], name: "index_ctgov.calculated_values_on_number_of_facilities"
  end

  create_table "central_contacts", force: :cascade do |t|
    t.string "nct_id"
    t.string "contact_type"
    t.string "name"
    t.string "phone"
    t.string "email"
    t.index ["contact_type"], name: "index_ctgov.central_contacts_on_contact_type"
  end

  create_table "conditions", force: :cascade do |t|
    t.string "nct_id"
    t.string "name"
    t.string "downcase_name"
    t.index ["downcase_name"], name: "index_ctgov.conditions_on_downcase_name"
    t.index ["name"], name: "index_ctgov.conditions_on_name"
  end

  create_table "countries", force: :cascade do |t|
    t.string "nct_id"
    t.string "name"
    t.boolean "removed"
  end

  create_table "design_group_interventions", force: :cascade do |t|
    t.string "nct_id"
    t.integer "design_group_id"
    t.integer "intervention_id"
    t.index ["design_group_id"], name: "index_ctgov.design_group_interventions_on_design_group_id"
    t.index ["intervention_id"], name: "index_ctgov.design_group_interventions_on_intervention_id"
  end

  create_table "design_groups", force: :cascade do |t|
    t.string "nct_id"
    t.string "group_type"
    t.string "title"
    t.text "description"
    t.index ["group_type"], name: "index_ctgov.design_groups_on_group_type"
  end

  create_table "design_outcomes", force: :cascade do |t|
    t.string "nct_id"
    t.string "outcome_type"
    t.text "measure"
    t.text "time_frame"
    t.string "population"
    t.text "description"
    t.index ["measure"], name: "index_ctgov.design_outcomes_on_measure"
    t.index ["outcome_type"], name: "index_ctgov.design_outcomes_on_outcome_type"
  end

  create_table "designs", force: :cascade do |t|
    t.string "nct_id"
    t.string "allocation"
    t.string "intervention_model"
    t.string "observational_model"
    t.string "primary_purpose"
    t.string "time_perspective"
    t.string "masking"
    t.text "masking_description"
    t.text "intervention_model_description"
    t.boolean "subject_masked"
    t.boolean "caregiver_masked"
    t.boolean "investigator_masked"
    t.boolean "outcomes_assessor_masked"
    t.index ["caregiver_masked"], name: "index_ctgov.designs_on_caregiver_masked"
    t.index ["investigator_masked"], name: "index_ctgov.designs_on_investigator_masked"
    t.index ["masking"], name: "index_ctgov.designs_on_masking"
    t.index ["outcomes_assessor_masked"], name: "index_ctgov.designs_on_outcomes_assessor_masked"
    t.index ["subject_masked"], name: "index_ctgov.designs_on_subject_masked"
  end

  create_table "detailed_descriptions", force: :cascade do |t|
    t.string "nct_id"
    t.text "description"
  end

  create_table "documents", force: :cascade do |t|
    t.string "nct_id"
    t.string "document_id"
    t.string "document_type"
    t.string "url"
    t.text "comment"
    t.index ["document_id"], name: "index_ctgov.documents_on_document_id"
    t.index ["document_type"], name: "index_ctgov.documents_on_document_type"
  end

  create_table "drop_withdrawals", force: :cascade do |t|
    t.string "nct_id"
    t.integer "result_group_id"
    t.string "ctgov_group_code"
    t.string "period"
    t.string "reason"
    t.integer "count"
    t.index ["period"], name: "index_ctgov.drop_withdrawals_on_period"
  end

  create_table "eligibilities", force: :cascade do |t|
    t.string "nct_id"
    t.string "sampling_method"
    t.string "gender"
    t.string "minimum_age"
    t.string "maximum_age"
    t.string "healthy_volunteers"
    t.text "population"
    t.text "criteria"
    t.text "gender_description"
    t.boolean "gender_based"
    t.index ["gender"], name: "index_ctgov.eligibilities_on_gender"
    t.index ["healthy_volunteers"], name: "index_ctgov.eligibilities_on_healthy_volunteers"
    t.index ["maximum_age"], name: "index_ctgov.eligibilities_on_maximum_age"
    t.index ["minimum_age"], name: "index_ctgov.eligibilities_on_minimum_age"
  end

  create_table "facilities", force: :cascade do |t|
    t.string "nct_id"
    t.string "status"
    t.string "name"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "country"
    t.index ["city"], name: "index_ctgov.facilities_on_city"
    t.index ["country"], name: "index_ctgov.facilities_on_country"
    t.index ["name"], name: "index_ctgov.facilities_on_name"
    t.index ["state"], name: "index_ctgov.facilities_on_state"
    t.index ["status"], name: "index_ctgov.facilities_on_status"
  end

  create_table "facility_contacts", force: :cascade do |t|
    t.string "nct_id"
    t.integer "facility_id"
    t.string "contact_type"
    t.string "name"
    t.string "email"
    t.string "phone"
    t.index ["contact_type"], name: "index_ctgov.facility_contacts_on_contact_type"
  end

  create_table "facility_investigators", force: :cascade do |t|
    t.string "nct_id"
    t.integer "facility_id"
    t.string "role"
    t.string "name"
  end

  create_table "id_information", force: :cascade do |t|
    t.string "nct_id"
    t.string "id_type"
    t.string "id_value"
    t.index ["id_type"], name: "index_ctgov.id_information_on_id_type"
  end

  create_table "intervention_other_names", force: :cascade do |t|
    t.string "nct_id"
    t.integer "intervention_id"
    t.string "name"
  end

  create_table "interventions", force: :cascade do |t|
    t.string "nct_id"
    t.string "intervention_type"
    t.string "name"
    t.text "description"
    t.index ["intervention_type"], name: "index_ctgov.interventions_on_intervention_type"
  end

  create_table "ipd_information_types", force: :cascade do |t|
    t.string "nct_id"
    t.string "name"
  end

  create_table "keywords", force: :cascade do |t|
    t.string "nct_id"
    t.string "name"
    t.string "downcase_name"
    t.index ["downcase_name"], name: "index_ctgov.keywords_on_downcase_name"
    t.index ["name"], name: "index_ctgov.keywords_on_name"
  end

  create_table "links", force: :cascade do |t|
    t.string "nct_id"
    t.string "url"
    t.text "description"
  end

  create_table "load_events", force: :cascade do |t|
    t.string "event_type"
    t.string "status"
    t.text "description"
    t.text "problems"
    t.integer "should_add"
    t.integer "should_change"
    t.integer "processed"
    t.string "load_time"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_type"], name: "index_support.load_events_on_event_type"
    t.index ["status"], name: "index_support.load_events_on_status"
  end

  create_table "mesh_headings", force: :cascade do |t|
    t.string "qualifier"
    t.string "heading"
    t.string "subcategory"
    t.index ["qualifier"], name: "index_mesh_headings_on_qualifier"
  end

  create_table "mesh_terms", force: :cascade do |t|
    t.string "qualifier"
    t.string "tree_number"
    t.string "description"
    t.string "mesh_term"
    t.string "downcase_mesh_term"
    t.index ["description"], name: "index_mesh_terms_on_description"
    t.index ["downcase_mesh_term"], name: "index_mesh_terms_on_downcase_mesh_term"
    t.index ["mesh_term"], name: "index_mesh_terms_on_mesh_term"
    t.index ["qualifier"], name: "index_mesh_terms_on_qualifier"
  end

  create_table "milestones", force: :cascade do |t|
    t.string "nct_id"
    t.integer "result_group_id"
    t.string "ctgov_group_code"
    t.string "title"
    t.string "period"
    t.text "description"
    t.integer "count"
    t.index ["period"], name: "index_ctgov.milestones_on_period"
  end

  create_table "outcome_analyses", force: :cascade do |t|
    t.string "nct_id"
    t.integer "outcome_id"
    t.string "non_inferiority_type"
    t.text "non_inferiority_description"
    t.string "param_type"
    t.decimal "param_value"
    t.string "dispersion_type"
    t.decimal "dispersion_value"
    t.string "p_value_modifier"
    t.float "p_value"
    t.string "ci_n_sides"
    t.decimal "ci_percent"
    t.decimal "ci_lower_limit"
    t.decimal "ci_upper_limit"
    t.string "ci_upper_limit_na_comment"
    t.string "p_value_description"
    t.string "method"
    t.text "method_description"
    t.text "estimate_description"
    t.text "groups_description"
    t.text "other_analysis_description"
    t.index ["dispersion_type"], name: "index_ctgov.outcome_analyses_on_dispersion_type"
    t.index ["param_type"], name: "index_ctgov.outcome_analyses_on_param_type"
  end

  create_table "outcome_analysis_groups", force: :cascade do |t|
    t.string "nct_id"
    t.integer "outcome_analysis_id"
    t.integer "result_group_id"
    t.string "ctgov_group_code"
  end

  create_table "outcome_counts", force: :cascade do |t|
    t.string "nct_id"
    t.integer "outcome_id"
    t.integer "result_group_id"
    t.string "ctgov_group_code"
    t.string "scope"
    t.string "units"
    t.integer "count"
  end

  create_table "outcome_measurements", force: :cascade do |t|
    t.string "nct_id"
    t.integer "outcome_id"
    t.integer "result_group_id"
    t.string "ctgov_group_code"
    t.string "classification"
    t.string "category"
    t.string "title"
    t.text "description"
    t.string "units"
    t.string "param_type"
    t.string "param_value"
    t.decimal "param_value_num"
    t.string "dispersion_type"
    t.string "dispersion_value"
    t.decimal "dispersion_value_num"
    t.decimal "dispersion_lower_limit"
    t.decimal "dispersion_upper_limit"
    t.text "explanation_of_na"
    t.index ["category"], name: "index_ctgov.outcome_measurements_on_category"
    t.index ["classification"], name: "index_ctgov.outcome_measurements_on_classification"
    t.index ["dispersion_type"], name: "index_ctgov.outcome_measurements_on_dispersion_type"
  end

  create_table "outcomes", force: :cascade do |t|
    t.string "nct_id"
    t.string "outcome_type"
    t.text "title"
    t.text "description"
    t.text "time_frame"
    t.text "population"
    t.date "anticipated_posting_date"
    t.string "anticipated_posting_month_year"
    t.string "units"
    t.string "units_analyzed"
    t.string "dispersion_type"
    t.string "param_type"
    t.index ["dispersion_type"], name: "index_ctgov.outcomes_on_dispersion_type"
    t.index ["param_type"], name: "index_ctgov.outcomes_on_param_type"
  end

  create_table "overall_officials", force: :cascade do |t|
    t.string "nct_id"
    t.string "role"
    t.string "name"
    t.string "affiliation"
    t.index ["affiliation"], name: "index_ctgov.overall_officials_on_affiliation"
    t.index ["nct_id"], name: "index_ctgov.overall_officials_on_nct_id"
  end

  create_table "participant_flows", force: :cascade do |t|
    t.string "nct_id"
    t.text "recruitment_details"
    t.text "pre_assignment_details"
  end

  create_table "pending_results", force: :cascade do |t|
    t.string "nct_id"
    t.string "event"
    t.string "event_date_description"
    t.date "event_date"
  end

  create_table "provided_documents", force: :cascade do |t|
    t.string "nct_id"
    t.string "document_type"
    t.boolean "has_protocol"
    t.boolean "has_icf"
    t.boolean "has_sap"
    t.date "document_date"
    t.string "url"
  end

  create_table "reported_events", force: :cascade do |t|
    t.string "nct_id"
    t.integer "result_group_id"
    t.string "ctgov_group_code"
    t.text "time_frame"
    t.string "event_type"
    t.string "default_vocab"
    t.string "default_assessment"
    t.integer "subjects_affected"
    t.integer "subjects_at_risk"
    t.text "description"
    t.integer "event_count"
    t.string "organ_system"
    t.string "adverse_event_term"
    t.integer "frequency_threshold"
    t.string "vocab"
    t.string "assessment"
    t.index ["event_type"], name: "index_ctgov.reported_events_on_event_type"
    t.index ["subjects_affected"], name: "index_ctgov.reported_events_on_subjects_affected"
  end

  create_table "responsible_parties", force: :cascade do |t|
    t.string "nct_id"
    t.string "responsible_party_type"
    t.string "name"
    t.string "title"
    t.string "organization"
    t.text "affiliation"
    t.index ["nct_id"], name: "index_ctgov.responsible_parties_on_nct_id"
    t.index ["organization"], name: "index_ctgov.responsible_parties_on_organization"
    t.index ["responsible_party_type"], name: "index_ctgov.responsible_parties_on_responsible_party_type"
  end

  create_table "result_agreements", force: :cascade do |t|
    t.string "nct_id"
    t.string "pi_employee"
    t.text "agreement"
  end

  create_table "result_contacts", force: :cascade do |t|
    t.string "nct_id"
    t.string "organization"
    t.string "name"
    t.string "phone"
    t.string "email"
    t.index ["organization"], name: "index_ctgov.result_contacts_on_organization"
  end

  create_table "result_groups", force: :cascade do |t|
    t.string "nct_id"
    t.string "ctgov_group_code"
    t.string "result_type"
    t.string "title"
    t.text "description"
    t.index ["result_type"], name: "index_ctgov.result_groups_on_result_type"
  end

  create_table "sanity_checks", force: :cascade do |t|
    t.string "table_name"
    t.string "nct_id"
    t.string "column_name"
    t.string "check_type"
    t.integer "row_count"
    t.text "description"
    t.boolean "most_current"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["check_type"], name: "index_support.sanity_checks_on_check_type"
    t.index ["column_name"], name: "index_support.sanity_checks_on_column_name"
    t.index ["nct_id"], name: "index_support.sanity_checks_on_nct_id"
    t.index ["table_name"], name: "index_support.sanity_checks_on_table_name"
  end

  create_table "sponsors", force: :cascade do |t|
    t.string "nct_id"
    t.string "agency_class"
    t.string "lead_or_collaborator"
    t.string "name"
    t.index ["agency_class"], name: "index_ctgov.sponsors_on_agency_class"
    t.index ["name"], name: "index_ctgov.sponsors_on_name"
  end

  create_table "studies", id: false, force: :cascade do |t|
    t.string "nct_id"
    t.string "nlm_download_date_description"
    t.date "study_first_submitted_date"
    t.date "results_first_submitted_date"
    t.date "disposition_first_submitted_date"
    t.date "last_update_submitted_date"
    t.date "study_first_submitted_qc_date"
    t.date "study_first_posted_date"
    t.string "study_first_posted_date_type"
    t.date "results_first_submitted_qc_date"
    t.date "results_first_posted_date"
    t.string "results_first_posted_date_type"
    t.date "disposition_first_submitted_qc_date"
    t.date "disposition_first_posted_date"
    t.string "disposition_first_posted_date_type"
    t.date "last_update_submitted_qc_date"
    t.date "last_update_posted_date"
    t.string "last_update_posted_date_type"
    t.string "start_month_year"
    t.string "start_date_type"
    t.date "start_date"
    t.string "verification_month_year"
    t.date "verification_date"
    t.string "completion_month_year"
    t.string "completion_date_type"
    t.date "completion_date"
    t.string "primary_completion_month_year"
    t.string "primary_completion_date_type"
    t.date "primary_completion_date"
    t.string "target_duration"
    t.string "study_type"
    t.string "acronym"
    t.text "baseline_population"
    t.text "brief_title"
    t.text "official_title"
    t.string "overall_status"
    t.string "last_known_status"
    t.string "phase"
    t.integer "enrollment"
    t.string "enrollment_type"
    t.string "source"
    t.string "limitations_and_caveats"
    t.integer "number_of_arms"
    t.integer "number_of_groups"
    t.string "why_stopped"
    t.boolean "has_expanded_access"
    t.boolean "expanded_access_type_individual"
    t.boolean "expanded_access_type_intermediate"
    t.boolean "expanded_access_type_treatment"
    t.boolean "has_dmc"
    t.boolean "is_fda_regulated_drug"
    t.boolean "is_fda_regulated_device"
    t.boolean "is_unapproved_device"
    t.boolean "is_ppsd"
    t.boolean "is_us_export"
    t.string "biospec_retention"
    t.text "biospec_description"
    t.string "ipd_time_frame"
    t.string "ipd_access_criteria"
    t.string "ipd_url"
    t.string "plan_to_share_ipd"
    t.string "plan_to_share_ipd_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["completion_date"], name: "index_ctgov.studies_on_completion_date"
    t.index ["disposition_first_submitted_date"], name: "index_ctgov.studies_on_disposition_first_submitted_date"
    t.index ["enrollment_type"], name: "index_ctgov.studies_on_enrollment_type"
    t.index ["last_known_status"], name: "index_ctgov.studies_on_last_known_status"
    t.index ["last_update_submitted_date"], name: "index_ctgov.studies_on_last_update_submitted_date"
    t.index ["nct_id"], name: "index_ctgov.studies_on_nct_id", unique: true
    t.index ["overall_status"], name: "index_ctgov.studies_on_overall_status"
    t.index ["phase"], name: "index_ctgov.studies_on_phase"
    t.index ["primary_completion_date"], name: "index_ctgov.studies_on_primary_completion_date"
    t.index ["primary_completion_date_type"], name: "index_ctgov.studies_on_primary_completion_date_type"
    t.index ["results_first_submitted_date"], name: "index_ctgov.studies_on_results_first_submitted_date"
    t.index ["source"], name: "index_ctgov.studies_on_source"
    t.index ["start_date"], name: "index_ctgov.studies_on_start_date"
    t.index ["start_date_type"], name: "index_ctgov.studies_on_start_date_type"
    t.index ["study_first_submitted_date"], name: "index_ctgov.studies_on_study_first_submitted_date"
    t.index ["study_type"], name: "index_ctgov.studies_on_study_type"
  end

  create_table "study_references", force: :cascade do |t|
    t.string "nct_id"
    t.string "pmid"
    t.string "reference_type"
    t.text "citation"
    t.index ["reference_type"], name: "index_ctgov.study_references_on_reference_type"
  end

  create_table "study_xml_records", force: :cascade do |t|
    t.string "nct_id"
    t.xml "content"
    t.datetime "created_study_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_study_at"], name: "index_support.study_xml_records_on_created_study_at"
    t.index ["nct_id"], name: "index_support.study_xml_records_on_nct_id"
  end

end
