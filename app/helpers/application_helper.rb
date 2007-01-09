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
      xml.div("class" => options[:class] || "bar", "style" => "width: #{100 * value / max_value}%")
    end
  end

  def path_with_links(directory)
    s = ''
    for dir in directory.ancestors
      s += link_to( dir[:name], { :controller => :directories, :action => :show, :path => dir.server.name + dir.path }) + '/'
    end
    s + h(directory[:name])
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
