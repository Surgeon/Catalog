class RegionsController < ApplicationController
  #rulbff8841
  def index
    @regions = Region.all
  end

  def show
    region = Region.find_by_friendly_url(params[:id])
    @rubrics = region.get_rubrics_from_2gis
  end

end
