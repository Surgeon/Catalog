class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.integer :region_id
      t.string :address
      t.string :website
      t.text :description
      t.string :email
      t.string :gis_id
      t.string :rand_company
      t.string :rand_city

      t.timestamps
    end
  end
end
