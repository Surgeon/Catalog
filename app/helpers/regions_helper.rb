module RegionsHelper

  def get_rubric_link(region, category, current_category, passive_class = '', active_class = '')
    css_class = category == current_category ?  active_class : passive_class
    link_to category[:name], region_category_path(region.friendly_url, category[:alias]), {:class => css_class}
  end

  def get_pagination(total, per_page, current_page, region, category)
    page_number = (total.to_f / per_page.to_f).ceil
    current_page = current_page.to_i
    output = ""
    output += (current_page - 1) > 0 ? "<li class='prev'>#{link_to '<', region_category_with_page_path(region.friendly_url,category[:alias],(current_page - 1).to_s)}</li>" : ''
    for i in 1..page_number
      case i
        when current_page
          output += "<li class='active'>#{link_to i, '#'}</li>"
        else
          output +=  "<li>#{link_to i, region_category_with_page_path(region.friendly_url,category[:alias],i.to_s)}</li>"
      end
    end
    output += (current_page + 1) < page_number + 1 ? "<li class='prev'>#{link_to '>', region_category_with_page_path(region.friendly_url,category[:alias],(current_page + 1).to_s)}</li>" : ''
    output
  end

end
