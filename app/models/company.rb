class Company < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :region
end
