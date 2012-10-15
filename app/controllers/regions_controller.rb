class RegionsController < ApplicationController
  #rulbff8841
  def index
    @regions = Region.all
  end

  def show

  end

end
