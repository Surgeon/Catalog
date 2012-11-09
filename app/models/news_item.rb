class NewsItem < ActiveRecord::Base
  attr_accessible :title, :preview, :body
end
