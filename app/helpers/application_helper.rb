module ApplicationHelper

  def get_info_head_text(head_text)
    if head_text
      head_text_out = head_text
    else
      head_text_out = t('head_text_all')
    end
  end

  def get_info_text(text)
    if @head_text
      text_out = text
    else
      text_out = t('text_all').html_safe
    end
  end

  def get_x_links(phrase)
    link_to phrase[:text], region_path(phrase[:city_id]), {:class => 'large'}
  end

end
