module RegionsHelper

  def get_rubric_link(region, category, current_category, passive_class = '', active_class = '')
    css_class = category == current_category ?  active_class : passive_class
    link_to category[:name], region_category_path(region.friendly_url, category[:alias]), {:class => css_class}
  end

end
