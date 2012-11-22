class Company < ActiveRecord::Base
  attr_accessible :name, :region_id, :address, :website, :email, :gis_id
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

  def add_cross_links_to_company()
    if !self.randomized
      a = Region.select(:id).to_a
      rnd = ''
      3.times do
        rnd += a.delete(a.sample).id.to_s + ','
      end
      rnd = rnd[0..rnd.size - 2]
      self.rand_city = rnd

      a = Phrase.select(:id).to_a
      rnd = ''
      3.times do
        rnd += a.delete(a.sample).id.to_s + ','
      end
      rnd = rnd[0..rnd.size - 2]
      self.rand_phrase = rnd

      self.randomized = true
      self.save
    end
  end

  def self.add_company_to_database(company)
    name = company[:name] ? company[:name] : nil
    region_id = Region.find_by_name(company[:city_name]) ? Region.find_by_name(company[:city_name]).id : nil
    address = company[:address] ? company[:address] : nil
    website = company[:contacts]['website'] ? company[:contacts]['website'] : nil
    email = company[:contacts]['email'] ? company[:contacts]['email'] : nil
    gis_id = company[:id] ? company[:id] : nil

    Company.find_or_create_by_gis_id(:name => name, :region_id => region_id, :address => address, :website => website, :email => email, :gis_id => gis_id)
  end

end
