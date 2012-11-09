class Company < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :region
  require 'net/http'
  require 'rexml/document'

  def self.get_company_from_2gis(company_id)
    query = "http://catalog.api.2gis.ru/profile?&version=1.3&key=rulbff8841&output=xml&id=#{company_id}"
    result = Net::HTTP.get(URI.parse(URI.encode(query)))
    doc = REXML::Document.new(result)
    company = {}
    profile = doc.elements['root/profile']
      company[:id] = profile.elements['id'] ? profile.elements['id'].text : nil
      company[:name] = profile.elements['name'] ? profile.elements['name'].text : nil
      company[:address] = profile.elements['address'] ? profile.elements['address'].text : nil
      company[:city_name] = profile.elements['city_name'] ? profile.elements['city_name'].text : nil
      company[:additional_info] = profile.elements['additional_info'] ? {} : nil
      company[:longitude] = profile.elements['lon'] ? profile.elements['lon'] : nil
      company[:latitude] = profile.elements['lat'] ? profile.elements['lat'] : nil
      if company[:additional_info]
        doc.elements.each('root/profile/additional_info/attr') do |add|
          company[:additional_info][add.attributes['name']] = add.text
        end
      end
      company[:rubrics] = profile.elements['rubrics'] ? [] : nil
      if company[:rubrics]
        doc.elements.each('root/profile/rubrics/rubric') do |rubric|
          company[:rubrics] << rubric.text
        end
      end
      company[:contacts] = profile.elements['contacts'] ? {} : nil
      if company[:contacts]
        doc.elements.each('root/profile/contacts/group') do |group|
          group.elements.each('contact') do |contact|
            company[:contacts][contact.attributes['type']] = contact.elements['value'].text
          end
        end
      end
    company
  end

end
