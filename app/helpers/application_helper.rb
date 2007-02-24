# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def self_and_ancestors_up_to(directory, parent_dir)
    if parent_dir.nil?
      directory.self_and_ancestors
    elsif directory.id == parent_dir.id
      [ directory ]
    else
       directory.self_and_ancestors_up_to(parent_dir) + [ parent_dir ]
    end
  end

  def ApplicationHelper::human_units_of(size)
    case 
      when size < 1.kilobyte: 'Bytes'
      when size < 1.megabyte: 'KB'
      when size < 1.gigabyte: 'MB'
      when size < 1.terabyte: 'GB'
      else                    'TB'
    end
  end

  def ApplicationHelper::human_size(size)
    units = human_units_of(size)
    "#{human_size_in(units, size)} #{units}"
  end
  
  def ApplicationHelper::human_size_in(units, size)
    scaled = scale_for_human_size(units, size)
    text = ('%.1f' % scaled).sub('.0', '')
    if text == '0' && scaled > 0
      return '> 0'
    else
      return text
    end
  end
  
  def bar(value, max_value, options)
    # Hack to deal with divide by zero
    if max_value == 0
      max_value = 1
    end
    xml = Builder::XmlMarkup.new
    xml.div("class" => "bar-outer") do
      xml.div(".", "class" => options[:class] || "bar", "style" => "width: #{(100 * value / max_value).to_i}%")
    end
  end

  def breadcrumbs_with_server_and_directory(server = nil, directory = nil)
    s = link_to_unless_current("root", :overwrite_params => {:server => nil, :path => nil, :page => nil})
    if server
      s += ' &#187 '
      s += link_to_unless_current(server.name, :overwrite_params => {:server => server.name, :path => nil, :page => nil})
    end
    if directory
      s += ' &#187 '
      # Note: need to reverse ancestors with behavior compatible to nested_set
      # (as opposed to better_nested_set)
      for dir in directory.ancestors.reverse
        s += link_to(dir[:name], :overwrite_params => {:path => dir.path, :page => nil}) + '/'
      end
      s += h(directory[:name])
    end
    return s
  end

  # This depends on the application running from a checked out svn version and
  # the command "svnversion" being available on the path
  def ApplicationHelper::earth_version_svn
    "revision " + IO::popen("svnversion #{RAILS_ROOT}") { |f| f.readline }
  end
  
  def ApplicationHelper::earth_version
    earth_version_svn
  end

  def ApplicationHelper::get_browser_warning(request)
    begin
      RAILS_DEFAULT_LOGGER.debug("user agent is #{request.user_agent}, accept is #{request.accept}")
      if request.user_agent.downcase =~ /firefox\/1.5/
        "WARNING: You appear to be using Firefox 1.5 - SVG support in this browser is flaky at best. Use <a href='http://www.mozilla.com/en-US/firefox/'>Firefox 2.0</a> for better results."
      else
        nil
      end
    rescue
      nil
    end
  end

private

  def ApplicationHelper::scale_for_human_size(units, size)
    case
      when units == 'Bytes': size
      when units == "KB": size / 1.0.kilobyte
      when units == "MB": size / 1.0.megabyte
      when units == "GB": size / 1.0.gigabyte
      when units == "TB": size / 1.0.terabyte
    end
  end
  
end
