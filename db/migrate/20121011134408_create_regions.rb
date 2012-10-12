class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.string :name
      t.text :description
      t.string :friendly_url
      t.string :gis_id
      t.string :rand_company
      t.string :rand_city

      t.timestamps
    end
  end
end
