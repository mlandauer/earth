module DirectoriesHelper
  def human_units_of(size)
    case 
      when size < 1.kilobyte: 'Bytes'
      when size < 1.megabyte: 'KB'
      when size < 1.gigabyte: 'MB'
      when size < 1.terabyte: 'GB'
      else                    'TB'
    end
  end
  
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
  
  def human_size_in(units, size)
    scaled = scale_for_human_size(units, size)
    text = ('%.1f' % scaled).sub('.0', '')
    if text == '0' && scaled > 0
      return '> 0'
    else
      return text
    end
  end
end
