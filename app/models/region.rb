class Region < ActiveRecord::Base
  attr_accessible :name, :description, :friendly_url, :gis_id
  has_many :companies

  def self.get_regions_from_2gis()
    #--get regions from 2gis API
    require 'net/http'
    require 'rexml/document'

    result = Net::HTTP.get(URI.parse(URI.encode('http://catalog.api.2gis.ru/project/list?version=1.3&output=xml&key=rulbff8841')))
    doc = REXML::Document.new(result)
    doc.elements.each('root/result/city') do |region|
      Region.create(:name => region.elements['name'].text, :friendly_url => region.elements['code'].text, :gis_id => region.elements['id'].text.to_i)
    end

  end
end
