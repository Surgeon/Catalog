class Region < ActiveRecord::Base
  attr_accessible :name, :description, :friendly_url, :gis_id
  has_many :companies
  has_one :category

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

  def self.get_root_rubrics_from_2gis
    #--get root rubrics from 2gis API
    require 'net/http'
    require 'rexml/document'
    Region.select('id, name').each do |region|
      result = Net::HTTP.get(URI.parse(URI.encode('http://catalog.api.2gis.ru/rubricator?version=1.3&output=xml&key=rulbff8841&where=' + region.name)))
      doc = REXML::Document.new(result)
      doc.elements.each('root/result/rubric') do |rubric|
        if rubric.elements['alias'].text == 'internet_svyaz_informacionnye_tekhnologii'
          Category.create(:name => rubric.elements['name'].text, :gis_id => rubric.elements['id'].text.to_i, :region_id => region.id)
        end
        #puts rubric.elements['alias']
      end
    end
  end

  def get_rubrics_from_2gis()
    #--get rubrics from 2gis API
    require 'net/http'
    require 'rexml/document'
    query = 'http://catalog.api.2gis.ru/rubricator?version=1.3&output=xml&parent_id=' + self.category.gis_id + '&key=rulbff8841&where=' + self.name
    result = Net::HTTP.get(URI.parse(URI.encode(query)))
    doc = REXML::Document.new(result)
    rubrics = []
    doc.elements.each('root/result/rubric') do |rubric|
      rubrics << rubric.elements['name'].text
    end
    rubrics
  end

  def get_companies_from_2gis(rubric,page)
    #--get companies from 2gis API
    require 'net/http'
    require 'rexml/document'
    query = 'http://catalog.api.2gis.ru/searchinrubric?what=' + rubric + '&where=' + self.name + '&page=' + page.to_s + '&pagesize=30&sort=relevance&version=1.3&key=rulbff8841&output=xml'
    result = Net::HTTP.get(URI.parse(URI.encode(query)))
    doc = REXML::Document.new(result)
    companies = []
    doc.elements.each('root/result/filial') do |company|
      companies << {:name => company.elements['name'].text, :id => company.elements['name'].text}
    end
    companies
  end
end
