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
      rubrics << {:name => rubric.elements['name'].text, :alias => rubric.elements['alias'].text}
    end
    rubrics
  end

  def get_companies_from_2gis(rubric,page)
    #--get companies from 2gis API
    require 'net/http'
    require 'rexml/document'
    query = 'http://catalog.api.2gis.ru/searchinrubric?what=' + rubric[:name] + '&where=' + self.name + '&page=' + page.to_s + '&pagesize=30&sort=relevance&version=1.3&key=rulbff8841&output=xml'
    result = Net::HTTP.get(URI.parse(URI.encode(query)))
    doc = REXML::Document.new(result)
    companies = []
    doc.elements.each('root/result/filial') do |company|
      companies << {:name => company.elements['name'].text, :id => company.elements['id'].text}
    end
    {:companies => companies, :total => doc.elements['root/result'].attributes['total']}
  end

  def self.get_rubric_name_from_url(rubrics, friendly_url)
    name = rubrics.detect {|r| r[:alias] == friendly_url}
    name ? name : rubrics[0]
  end

  def add_cross_links_to_region()
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

  def get_region_cross_links
    c_words = Phrase.select('`text`, `case`').find(self.rand_phrase.split(','))
    c_cities = Region.select('`friendly_url`, `name`').find(self.rand_city.split(','))
    phrases = []
    c_words.each_with_index do |w , i|
      phrases << { :text => w.text + ' ' + YandexInflect.inflections(c_cities[i].name)[w.case.to_i]['__content__'], :city_id => c_cities[i].friendly_url }
    end
    phrases
  end

end
