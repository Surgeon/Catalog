class NewsItemController < ApplicationController
  def index
  end

  def show
    @news = NewsItem.find(params[:id])
  end
end
