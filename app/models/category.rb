class Category < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name, :region_id, :gis_id
  belongs_to :region
end
