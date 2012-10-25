class RegionsController < ApplicationController
  #rulbff8841
  def index
    @regions = Region.all
  end

  def show
    id = params[:id] ? params[:id] : params[:region_id]
    @region = Region.find_by_friendly_url(id)
    @rubrics = @region.get_rubrics_from_2gis
    @rubric = Region.get_rubric_name_from_url(@rubrics,params[:category_name])
    @companies = @region.get_companies_from_2gis(@rubric,1)
  end

end
