class AddRecruiterAgencyToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :recruiter_agency, :boolean, :default => false

  end
end
