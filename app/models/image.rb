class Image < ActiveRecord::Base
  attr_accessible :pic
  has_attached_file :pic, :styles => {:big => "600x400>", :medium => "300x300>", :thumb => "100x100>" }
end
