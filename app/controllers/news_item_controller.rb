class NewsItemController < ApplicationController
  def index
    @news = NewsItem.order("updated_at DESC").paginate(:page => params[:page], :per_page => 5)
  end

  def show
    @news = NewsItem.find(params[:id])
  end
end
