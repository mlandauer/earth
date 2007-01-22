# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def human_units_of(size)
    case 
      when size < 1.kilobyte: 'Bytes'
      when size < 1.megabyte: 'KB'
      when size < 1.gigabyte: 'MB'
      when size < 1.terabyte: 'GB'
      else                    'TB'
    end
  end
  
  def human_size_in(units, size)
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
    xml.div("class" => "graph") do
      xml.div("class" => options[:class] || "bar", "style" => "width: #{(100 * value / max_value).to_i}%")
    end
  end

  def breadcrumbs_with_server_and_directory(server = nil, directory = nil)
    s = link_to_unless_current("root", :overwrite_params => {:server => nil, :path => nil})
    if server
      s += ' &#187 '
      s += link_to_unless_current(server.name, :overwrite_params => {:server => server.name, :path => nil})
    end
    if directory
      s += ' &#187 '
      # Note: need to reverse ancestors with behavior compatible to nested_set
      # (as opposed to better_nested_set)
      for dir in directory.ancestors.reverse
        s += link_to(dir[:name], :overwrite_params => {:path => dir.path}) + '/'
      end
      s += h(directory[:name])
    end
    return s
  end

private

  def scale_for_human_size(units, size)
    case
      when units == 'Bytes': size
      when units == "KB": size / 1.0.kilobyte
      when units == "MB": size / 1.0.megabyte
      when units == "GB": size / 1.0.gigabyte
      when units == "TB": size / 1.0.terabyte
    end
  rescue
    nil
  end
  
end
