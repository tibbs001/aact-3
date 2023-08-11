class CreateIndices < ActiveRecord::Migration[7.0]

  #  DON'T FORGET.....
  # If you add an index, add it to indexes method in Util::Updater.  (or find a better way)

  def change

    add_index "ctgov.overall_officials", :nct_id
    add_index "ctgov.responsible_parties", :nct_id
    add_index "ctgov.studies", :nct_id, :unique => true

    add_index "ctgov.baseline_measurements", :category
    add_index "ctgov.baseline_measurements", :classification
    add_index "ctgov.baseline_measurements", :dispersion_type
    add_index "ctgov.baseline_measurements", :param_type
    add_index "ctgov.browse_conditions", :downcase_mesh_term
    add_index "ctgov.browse_conditions", :mesh_term
    add_index "ctgov.browse_conditions", :nct_id
    add_index "ctgov.browse_interventions", :downcase_mesh_term
    add_index "ctgov.browse_interventions", :mesh_term
    add_index "ctgov.browse_interventions", :nct_id
    add_index "ctgov.calculated_values", :actual_duration
    add_index "ctgov.calculated_values", :months_to_report_results
    add_index "ctgov.calculated_values", :number_of_facilities
    add_index "ctgov.central_contacts", :contact_type
    add_index "ctgov.conditions", :name
    add_index "ctgov.conditions", :downcase_name
    add_index "ctgov.design_groups", :group_type
    add_index "ctgov.design_group_interventions", :design_group_id
    add_index "ctgov.design_group_interventions", :intervention_id
    add_index "ctgov.design_outcomes", :outcome_type
    add_index "ctgov.designs", :masking
    add_index "ctgov.designs", :subject_masked
    add_index "ctgov.designs", :caregiver_masked
    add_index "ctgov.designs", :investigator_masked
    add_index "ctgov.designs", :outcomes_assessor_masked
    add_index "ctgov.documents", :document_id
    add_index "ctgov.documents", :document_type
    add_index "ctgov.drop_withdrawals", :period
    add_index "ctgov.eligibilities", :gender
    add_index "ctgov.eligibilities", :healthy_volunteers
    add_index "ctgov.eligibilities", :minimum_age
    add_index "ctgov.eligibilities", :maximum_age
    add_index "ctgov.facilities", :status
    add_index "ctgov.facilities", :name
    add_index "ctgov.facilities", :city
    add_index "ctgov.facilities", :state
    add_index "ctgov.facilities", :country
    add_index "ctgov.facility_contacts", :contact_type
    add_index "ctgov.id_information", :id_type
    add_index "ctgov.interventions", :intervention_type
    add_index "ctgov.keywords", :name
    add_index "ctgov.keywords", :downcase_name
    add_index "ctgov.milestones", :period
    add_index "ctgov.overall_officials", :affiliation
    add_index "ctgov.outcome_analyses", :dispersion_type
    add_index "ctgov.outcome_analyses", :param_type
    add_index "ctgov.outcome_measurements", :dispersion_type
    add_index "ctgov.outcome_measurements", :category
    add_index "ctgov.outcome_measurements", :classification
    add_index "ctgov.outcomes", :dispersion_type
    add_index "ctgov.outcomes", :param_type
    add_index "ctgov.reported_events", :event_type
    add_index "ctgov.reported_events", :subjects_affected
    add_index "ctgov.responsible_parties", :organization
    add_index "ctgov.responsible_parties", :responsible_party_type
    add_index "ctgov.result_contacts", :organization
    add_index "ctgov.result_groups", :result_type
    add_index "ctgov.sponsors", :agency_class
    add_index "ctgov.sponsors", :name
    add_index "ctgov.studies", :completion_date
    add_index "ctgov.studies", :enrollment_type
    add_index "ctgov.studies", :last_known_status
    add_index "ctgov.studies", :overall_status
    add_index "ctgov.studies", :phase
    add_index "ctgov.studies", :primary_completion_date
    add_index "ctgov.studies", :primary_completion_date_type
    add_index "ctgov.studies", :source
    add_index "ctgov.studies", :start_date
    add_index "ctgov.studies", :start_date_type
    add_index "ctgov.studies", :study_type
    add_index "ctgov.studies", :study_first_submitted_date
    add_index "ctgov.studies", :results_first_submitted_date
    add_index "ctgov.studies", :disposition_first_submitted_date
    add_index "ctgov.studies", :last_update_submitted_date
    add_index "ctgov.study_references", :reference_type
  end

end
