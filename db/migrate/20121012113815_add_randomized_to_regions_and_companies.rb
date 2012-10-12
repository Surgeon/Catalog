class AddRandomizedToRegionsAndCompanies < ActiveRecord::Migration
  def change
    add_column :regions, :randomized, :boolean
    add_column :companies, :randomized, :boolean
  end
end
