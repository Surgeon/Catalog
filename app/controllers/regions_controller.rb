class RegionsController < ApplicationController
  #rulbff8841
  def index
    @regions = Region.all
    @news = NewsItem.limit(5)
  end

  def show
    id = params[:id] ? params[:id] : params[:region_id]
    @page = params[:page].nil? ? '1' : params[:page]
    @region = Region.find_by_friendly_url(id)
    @rubrics = @region.get_rubrics_from_2gis
    @rubric = Region.get_rubric_name_from_url(@rubrics,params[:category_name])
    result = @region.get_companies_from_2gis(@rubric,@page)
    @companies = result[:companies]
    @total = result[:total]
    @phrases = @region.get_region_cross_links
    @is_pagination = true
  end

  def search
    result = Region.search_companies_with_2gis(params[:keyword], params[:city])
    @companies = result[:companies]
    @total = 50
    @page = 1
    render :show
  end

end
