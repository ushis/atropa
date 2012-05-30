require 'atropa_page_links'

module ApplicationHelper

  def flash_all
    ret = ''
    flash.each { |key, msg| ret << content_tag('div', msg, :class => 'flash ' + key.to_s) }
    ret.html_safe
  end

  def error_list(errors)
    return nil if errors.size == 0

    content_tag 'ul', class: 'errors' do
      errors.collect { |e| content_tag('li', e) }.join('').html_safe
    end
  end

  def gravatar_tag(id, size = 50)
    uri = "https://secure.gravatar.com/avatar/#{id}?d=mm&s=#{size.to_s}"
    image_tag uri, alt: 'Gravatar', width: size, height: size
  end

  def paginate(collection)
    will_paginate collection, renderer: AtropaPageLinks::Renderer
  end
end
