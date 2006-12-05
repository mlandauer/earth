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
  
  def human_size_in(units, size)
    scaled = scale_for_human_size(units, size)
    text = ('%.1f' % scaled).sub('.0', '')
    if text == '0' && scaled > 0
      return '> 0'
    else
      return text
    end
  end
  
  def chart(points, options)
    object = chart_flash_object(options[:type])
    xm = Builder::XmlMarkup.new(:ident=>2)
    xml = xm.graph('yaxisname' => options[:yaxisname], 'xaxisname' => options[:xaxisname], 'numdivlines' => 3, 'zeroPlaneColor' => '333333', 'zeroPlaneAlpha' => 40) {
      points.each do |p|
        xm.set(p)
      end
    }
    xml.tr!('"', "'")
    return <<EOF
    <OBJECT classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" 
codebase="http://download.macromedia.com/
pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0"
WIDTH="#{options[:width]}" HEIGHT="#{options[:height]}" id="#{object}" ALIGN="">
<PARAM NAME=movie VALUE="/charts/#{object}.swf">
<PARAM NAME="FlashVars" value="&dataXML=#{xml}">
<PARAM NAME=quality VALUE=high>
<PARAM NAME=bgcolor VALUE=#{options[:bgcolor]}>
<EMBED src="/charts/#{object}.swf" FlashVars="&dataXML=#{xml}" quality=high bgcolor=#{options[:bgcolor]} WIDTH="#{options[:width]}" HEIGHT="#{options[:height]}" NAME="#{object}" 
ALIGN=""
TYPE="application/x-shockwave-flash" PLUGINSPAGE="http://www.macromedia.com/go/getflashplayer"></EMBED>
</OBJECT>
EOF
  end
  
  def HSVtoRGB(h, s, v)
	if s == 0 
		# achromatic (grey)
		r = v
		g = v
		b = v
		return;
	end
	h = h / 60			# sector 0 to 5
	i = floor( h )
	f = h - i			# factorial part of h
	p = v * ( 1 - s )
	q = v * ( 1 - s * f )
	t = v * ( 1 - s * ( 1 - f ) )
	case
      when i == 0: r = v; g = t; b = p
      when i == 1: r = q; g = v; b = p
      when i == 2: r = p; g = v; b = t
      when i == 3: r = p; g = q; b = v
      when i == 4: r = t; g = p; b = v
	  else         r = v; g = p; b = q
	end
	return [r, g, b]
  end
  
  def to_hex(color)
    "#" + color[0].to_s(16) + color[1].to_s(16) + color[2].to_s(16) 
  end

private

  # Given a graph type return the flash object name
  def chart_flash_object(type)
    case
      when type == :column: "FC2Column"
      when type == :pie: "FC2Pie3D"
      when type == :bar: "FC2Bar"
      else nil
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
  
end
