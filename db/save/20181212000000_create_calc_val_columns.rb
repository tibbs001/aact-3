class CreateCalcValColumns < ActiveRecord::Migration[7.0]

  def up
    add_column 'calculated_values', :number_of_primary_outcomes_to_measure, :integer
    add_column 'calculated_values', :number_of_secondary_outcomes_to_measure, :integer
    add_column 'calculated_values', :number_of_other_outcomes_to_measure, :integer
  end

  def down
    remove_column 'calculated_values', :number_of_primary_outcomes_to_measure, :integer
    remove_column 'calculated_values', :number_of_secondary_outcomes_to_measure, :integer
    remove_column 'calculated_values', :number_of_other_outcomes_to_measure, :integer
  end

end
