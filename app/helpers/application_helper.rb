require 'digest/md5'

module ApplicationHelper

  def flash_all
    ret = ''
    flash.each {|key, msg| ret += content_tag 'div', msg, :class => 'flash ' + key.to_s}
    ret.html_safe
  end

  def error_list(errors)
    return nil if errors.size == 0

    content_tag 'ul', class: 'errors' do
      errors.collect { |e| content_tag('li', e) }.join('').html_safe
    end
  end

  def gravatar_tag(email, size = 50)
    size = size.to_s
    uri = 'https://secure.gravatar.com/avatar/'
    uri << Digest::MD5.hexdigest(email.strip.downcase)
    uri << "?d=mm&s=#{size}"
    image_tag uri, alt: 'Gravatar', width: size, height: size
  end

  def pagination_link(txt, url, page)
    url[:page] = page
    content_tag 'li', link_to(txt, url)
  end

  def pagination_current(page)
    content_tag 'li', content_tag('span', page)
  end

  def pagination_links(info)
    links = info[:current] > 1 ? pagination_link('<', info[:url], info[:current] - 1) : ''

    (1..info[:total]).each do |i|
      links << (info[:current] != i ? pagination_link(i, info[:url], i) : pagination_current(i))
    end

    links << pagination_link('>', info[:url], info[:current] + 1) if info[:current] < info[:total]
    content_tag 'ul', links.html_safe, class: 'pagination'
  end
end
