require 'atropa_page_links'

module ApplicationHelper

  def flash_all
    flash.inject('') do |html, item|
      html << content_tag(:div, item[1], :class => "flash #{item[0].to_s}")
    end.html_safe
  end

  def error_list(errors)
    return nil if errors.size == 0

    content_tag :ul, class: 'errors' do
      errors.inject('') { |html, e| html << content_tag(:li, e) }.html_safe
    end
  end

  def gravatar_tag(id, size = 50)
    uri = "https://secure.gravatar.com/avatar/#{id}?d=mm&s=#{size.to_s}"
    image_tag uri, alt: 'Gravatar', width: size, height: size
  end

  def paginate(collection)
    will_paginate collection, inner_window: 3, renderer: AtropaPageLinks::Renderer
  end
end
