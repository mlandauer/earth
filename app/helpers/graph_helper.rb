module GraphHelper

  def dump_segments(directory, level_segment_array)

    logger.debug("Dumping segments for directory #{@directory.path}:")
    level_index = 1
    level_segment_array[1..-1].each do |level_segments|
      logger.debug("  Level ##{level_index}:")
      level_segments.each do |segment|
        logger.debug("    #{segment.inspect}")
      end
      level_index += 1
    end
  end
  
  # Given a directory sub-tree, create a 2-dimensional array for
  # presentation of a radial graph. The first dimension corresponds to
  # the level in the sub-tree and the second dimension to the circle
  # segments on that level.
  def create_directory_segments(directory)

    level_segment_array = []

    # Empty for root level
    level_segment_array << nil

    # Prepare arrays for each level below root
    for level in (1..@level_count)
      level_segment_array << Array.new
    end

    # Recursively fill level arrays
    add_segments(1, 360.0, level_segment_array, directory, directory.size)

    # Post-process level arrays
    for level in (1..@level_count)
      postprocess_segments(level, level_segment_array[level])
    end

    #dump_segments(directory, level_segment_array)

    level_segment_array
  end

  #
  #  Given a list of servers, create a circle (associated with the
  #  server name and the total size of the files on that server) for
  #  each of them, with the circle area corresponding to the relative
  #  size of the data.  Arrange the circles so that the largest one
  #  is in the center and smaller ones get arranged around it.
  #
  def create_server_circles()
    #
    #  For each server, determine a (relative) circle radius and sort
    #  descending by the radius.
    #
    servers_and_radius = @servers.map{|s| [s, Math.sqrt(s.size) ]}
    servers_and_radius.sort! do |entry1, entry2|
      entry1[1] - entry2[1]
    end

    gap = 3
    
    #
    #
    #
    max_radius = 20
    radius_scale = servers_and_radius[0][1] / max_radius

    server_circles = Array.new
    server_circles << ServerCircle.new(0, 0, servers_and_radius[0][1] / radius_scale, 
                                       servers_and_radius[0][0])
    servers_and_radius[1..-1].each do |server_and_radius|

      radius = server_and_radius[1] / radius_scale

      if server_circles.size == 1
        x = 0
        y = -@server_circles[0].radius - radius - gap
        server_circles << ServerCircle.new(x, y, radius, server)
      else
        min_distance = -1
        server_circles.each do |circle1|
          server_circles.each do |circle2|
            if circle1 != circle2

              xi, yi, xi_prime, yi_prime = circle_circle_intersection(circle1.x,
                                                                      circle1.y,
                                                                      circle1.radius + radius + gap,
                                                                      circle2.x,
                                                                      circle2.y,
                                                                      circle2.radius + radius + gap)

              if not xi.nil?

                loc1 = [ xi, yi ]
                loc2 = [ xi_prime, yi_prime ]

                [loc1, loc2].each do |loc|

                  cx = loc[0]
                  cy = loc[1]
                  
                  overlaps = false
                  server_circles.each do |circle|
                    if circle.overlaps(cx, cy, radius)
                      overlaps = true
                      break
                    end
                  end

                  if not overlaps
                    distance = Math.sqrt(cx*cx + cy*cy)
                    
                    if min_distance < 0 or distance < min_distance or ((distance-min_distance) < 0.00001 and cy < y)
                      x = cx
                      y = cy
                      min_distance = distance
                    end
                  end
                end
              end
            end
          end
        end

        server_circles << ServerCircle.new(x, y, radius, server_and_radius[0])
        total_radius = Math.sqrt(x*x + y*y) + radius
        if total_radius > max_radius
          max_radius = total_radius
        end
      end
    end
    [ server_circles, max_radius ]
  end

private

  # Calculate the next outer radius of a segment-ring so that the area of the
  # segment rings stays constant.
  #
  # given radii r1, r2 find r3
  #
  # a1 = pi * r1 * r1   -> area within r1
  # a2 = pi * r2 * r2   -> area within r2
  # a3 = pi * r3 * r3   -> area within r3
  #
  # a1' = a2 - a1       -> area of ring between r1 and r2
  # a1' = pi * r2 * r2 - pi * r1 * r1
  #
  # a2' = a3 - a2       -> area of ring between r2 and r3
  # a2' = pi * r3 * r3 - pi * r2 * r2
  #
  # a2' = a1'           -> area should remain constant
  #
  # solve for r3:
  #
  # pi * r2 * r2 - pi * r1 * r1  =  pi * r3 * r3 - pi * r2 * r2        |  /pi
  # r2 * r2 - r1 * r1            =  r3 * r3 - r2 * r2                  |  /pi
  # r2 * r2 - r1 * r1            =  r3 * r3 - r2 * r2                  |  + r2 * r2
  # 2 * r2 * r2 - r1 * r1        =  r3 * r3                            |  sqrt        
  # r3                           =  Math.sqrt(2 * r2 * r2 - r1 * r1)
  #
  def get_level_radii
    if @level_radii.nil?
      @level_radii = [ 25, 46 ]
      while @level_radii.size <= @level_count + 1
        r1 = @level_radii[@level_radii.size - 2]
        r2 = @level_radii[@level_radii.size - 1]
        @level_radii << Math.sqrt(2 * r2 * r2 - r1 * r1)
      end
    end
    @level_radii
  end

  def GraphHelper.hue_to_rgb( v1, v2, vH )
    vH += 1 if ( vH < 0 )
    vH -= 1 if ( vH > 1 ) 
    if ( ( 6 * vH ) < 1 ) 
      return ( v1 + ( v2 - v1 ) * 6 * vH )
    elsif ( ( 2 * vH ) < 1 ) 
      return ( v2 )
    elsif ( ( 3 * vH ) < 2 ) 
      return ( v1 + ( v2 - v1 ) * ( ( 2.0 / 3 ) - vH ) * 6 )
    else
      return ( v1 )
    end
  end

  def GraphHelper.hsl_to_rgb(h, s, l) 
    if s == 0
      r = l * 255
      g = l * 255
      b = l * 255
    else
      if l < 0.5
        var_2 = l * ( 1 + s )
      else
        var_2 = ( l + s ) - ( s * l )
      end
      var_1 = 2 * l - var_2

      r = 255 * hue_to_rgb( var_1, var_2, h + ( 1.0 / 3.0 ) )
      g = 255 * hue_to_rgb( var_1, var_2, h )
      b = 255 * hue_to_rgb( var_1, var_2, h - ( 1.0 / 3.0 ) )

      r = [0, [255, r].min].max.to_i
      g = [0, [255, g].min].max.to_i
      b = [0, [255, b].min].max.to_i
    end
    "rgb(#{r},#{g},#{b})"
  end  

  class Point

    attr_reader :x, :y

    def initialize(x, y)
      @x = x
      @y = y
    end

    def to_s
      "#{@x},#{@y}"
    end
  end

  def format_human(size)
    units = human_units_of(size)
    "#{human_size_in(units, size)} #{units}"
  end

  def add_segments(level, angle_range, level_segment_array, directory, parent_size)

    directory.cached_size = directory.size unless directory.nil?
    
    if (level > @level_count)
      return
    end

    level_segments = level_segment_array[level]

    if directory.nil?
      empty_segment = Segment.new(:angle => angle_range, :type => :empty)
      level_segments << empty_segment
      add_segments(level + 1, angle_range, level_segment_array, nil, 0)
    else

      if parent_size == 0
        parent_size = 1
      end

      small_directories = Array.new
      big_directories = Array.new
      small_directories_size = 0

      directory.children.each do |child|
        child.cached_size = child.size unless child.nil?
        child_size = child.size
        segment_angle = child_size * angle_range / parent_size
        if segment_angle >= @minimum_angle
          big_directories << child
        else
          small_directories_size += child_size
          small_directories << child
        end
      end

      big_files = Array.new
      small_files = Array.new
      small_files_size = 0

      directory.files.each do |file|
        segment_angle = file.size * angle_range / parent_size
        if segment_angle >= @minimum_angle
          big_files << file
        else
          small_files_size += file.size
          small_files << file
        end
      end

      small_files_angle = small_files_size * angle_range / parent_size
      if @remainder_mode == :drop and small_files_angle < @minimum_angle
        parent_size -= small_files_size
        small_files = []
        small_files_size = 0
        small_files_angle = 0
      end

      small_directories_angle = small_directories_size * angle_range / parent_size
      if @remainder_mode == :drop and small_directories_angle < @minimum_angle
        parent_size -= small_directories_size
        small_directories = []
        small_directories_size = 0
        small_directories_angle = 0
      end

      small_files_angle = small_files_size * angle_range / parent_size
      if @remainder_mode == :drop and small_files_angle < @minimum_angle
        parent_size -= small_files_size
        small_files = []
        small_files_size = 0
        small_files_angle = 0
      end

      if small_directories_angle > 0
        if small_directories.size > 1
          segment = Segment.new(:angle => small_directories_angle, 
                                :type => ((small_directories_angle >= @minimum_angle or @remainder_mode != :empty) ? :directory : :empty),
                                :name => "#{small_directories.size} directories", 
                                :tooltip => "#{small_directories.size} directories in ...#{directory.path_relative_to(@directory)}/ (#{format_human(small_directories_size)})")
        else
          child = small_directories[0]
          segment = Segment.new(:angle => small_directories_angle, 
                                :type => ((small_directories_angle >= @minimum_angle or @remainder_mode != :empty) ? :directory : :empty),
                                :name => "#{child.name}/", 
                                :href => url_for(:controller => :graph, 
                                                 :escape => false,
                                                 :overwrite_params => {:server => @server.name, 
                                                                       :action => nil,
                                                                       :path => child.path}),
                                :tooltip => "...#{child.path_relative_to(@directory)}/ (#{format_human(child.size)})")
        end
        level_segments << segment
        
        add_segments(level + 1, small_directories_angle, level_segment_array, nil, 0)
      end

      big_directories.each do |big_directory|
        segment_angle = big_directory.size * angle_range / parent_size
        segment = Segment.new(:angle => segment_angle, 
                              :type => :directory,
                              :name => "#{big_directory.name}/", 
                              :href => url_for(:controller => :graph, 
                                               :escape => false,
                                               :overwrite_params => {:server => @server.name, 
                                                                     :action => nil,
                                                                     :path => big_directory.path}),
                              :tooltip => "...#{big_directory.path_relative_to(@directory)}/ (#{format_human(big_directory.size)})")
        level_segments << segment
        add_segments(level + 1, segment_angle, level_segment_array, big_directory, big_directory.size)
      end
      
      if small_files_angle > 0
        if small_files.size > 1
          small_files_segment = Segment.new(:angle => small_files_angle, 
                                            :type => ((small_files_angle >= @minimum_angle or @remainder_mode != :empty) ? :file : :empty),
                                            :name => "#{small_files.size} files",
                                            :tooltip => "#{small_files.size} files in ...#{directory.path_relative_to(@directory)}/ (#{format_human(small_files_size)})")
        else
          file = small_files[0]
          small_files_segment = Segment.new(:angle => small_files_angle, 
                                            :type => ((small_files_angle >= @minimum_angle or @remainder_mode != :empty) ? :file : :empty),
                                            :name => file.name,
                                            :tooltip => "...#{directory.path_relative_to(@directory)}/#{file.name} (#{format_human(file.size)})")
        end
        level_segments << small_files_segment
      end

      files_size = 0
      files_total_angle = small_files_angle
      big_files.each do |file|
        files_size += file.size

        angle = file.size * angle_range / parent_size
        file_segment = Segment.new(:angle => angle, 
                                   :type => :file,
                                   :name => file.name,
                                   :tooltip => "...#{directory.path_relative_to(@directory)}/#{file.name} (#{format_human(file.size)})")
        level_segments << file_segment
        files_total_angle += angle
      end

      add_segments(level + 1, files_total_angle, level_segment_array, nil, 0)
    end
  end


  class Segment

    attr_reader :angle
    attr_reader :name
    attr_reader :href
    attr_reader :segment_id
    attr_reader :tooltip
    attr_writer :angle
    attr_writer :start_angle
    attr_writer :inner_radius
    attr_writer :outer_radius
    attr_writer :level
    attr_writer :segment_id

    def initialize(args)
      @angle = args[:angle]
      @name = args[:name] || ""
      @href = args[:href]
      @tooltip = args[:tooltip]
      @type = args[:type]
    end

    def empty?
      @type == :empty
    end

    def directory?
      @type == :directory
    end

    def get_point_on_circle(radius, angle)

      return Point.new(Math.cos(angle * Math::PI / 180.0) * radius,
                       Math.sin(angle * Math::PI / 180.0) * radius)
    end

    def get_color
      GraphHelper.hsl_to_rgb((@start_angle + @angle /2) / 360.0, 0.5, 0.8 - @level * 0.05)
    end

    def get_svg_divider_path(level)
      get_svg_divider_path_radius(@inner_radius, @outer_radius)
    end 

    def get_svg_divider_path_radius(inner, outer)
      "M#{get_point_on_circle(inner, @start_angle)} L#{get_point_on_circle(outer, @start_angle)}"
    end 

    def get_svg_path_internal(level, radius, reverse=false)
      if @angle < 360

        angle1 = @start_angle
        angle2 = @start_angle + @angle

        if reverse
          angle2, angle1 = angle1, angle2
        end

        middle_start = get_point_on_circle(radius, angle1)
        middle_end = get_point_on_circle(radius, angle2)

        if @angle < 180
          flags = 0
        else
          flags = 1
        end

        if reverse
          flags2 = 0
        else
          flags2 = 1
        end

        "M#{middle_start} " + \
        "A#{radius},#{radius} 0 #{flags},#{flags2} #{middle_end} "
      else
        middle_start = get_point_on_circle(radius, 90)
        middle_end = get_point_on_circle(radius, 270)

        "M#{middle_start} " + \
        "A#{radius},#{radius} 0 0,1 #{middle_end} " + \
        "A#{radius},#{radius} 0 0,1 #{middle_start} "
      end
    end

    def get_svg_text_path(level)
      get_svg_path_internal(level, (@inner_radius + @outer_radius) / 2, @start_angle + @angle/2 < 180)
    end

    def get_svg_path_outer(level)
      get_svg_path_internal(level, @outer_radius)
    end

    def get_svg_path(extension=false, reverse=false)

        if not extension
          radius1 = @inner_radius
          radius2 = @outer_radius
        else
          radius1 = @outer_radius
          radius2 = @outer_radius + 10
        end

      if @angle < 360

        angle1 = @start_angle
        angle2 = @start_angle + @angle

        if reverse
          angle2, angle1 = angle1, angle2
        end

        inner_start = get_point_on_circle(radius1, angle1)
        inner_end = get_point_on_circle(radius1, angle2)
        outer_end = get_point_on_circle(radius2, angle2)
        outer_start = get_point_on_circle(radius2, angle1)
      
        if @angle < 180
          flags = "0"
        else
          flags = "1"
        end
        "M#{inner_start} " + \
        "A#{radius1},#{radius1} 0 #{flags},1 #{inner_end} " + \
        "L#{outer_end} " + \
        "A#{radius2},#{radius2} 0 #{flags},0 #{outer_start} " + \
        "L#{inner_start} "
      else
        inner_start = get_point_on_circle(radius1, 0)
        inner_end = get_point_on_circle(radius1, 180)
        outer_end = get_point_on_circle(radius2, 180)
        outer_start = get_point_on_circle(radius2, 0)

        "M#{inner_start} " + \
        "A#{radius1},#{radius1} 0 0,1 #{inner_end} " + \
        "A#{radius1},#{radius1} 0 0,1 #{inner_start} " + \
        "L#{outer_start} " + \
        "A#{radius2},#{radius2} 0 0,0 #{outer_end} " + \
        "A#{radius2},#{radius2} 0 0,0 #{outer_start} " + \
        "L#{inner_start} "
      end
    end

  end

  def postprocess_segments(level, level_segments)
    start_angle = 10
    segment_id = 1

    level_radii = get_level_radii

    inner_radius = level_radii[level - 1]
    outer_radius = level_radii[level]

    prev_segment = nil
    remove_segment_indices = Array.new
    level_segments.each_index do | index |
      segment = level_segments[index]
      if (not prev_segment.nil?) and prev_segment != segment and prev_segment.empty? and segment.empty?
        prev_segment.angle += segment.angle
        remove_segment_indices << index
      else
        segment.start_angle = start_angle

        segment.inner_radius = inner_radius
        segment.outer_radius = outer_radius
        segment.level = level
        segment.segment_id = segment_id

        segment_id += 1
        prev_segment = segment
      end
      start_angle += segment.angle
    end
    
    remove_segment_indices.reverse.each do |index|
      level_segments.delete_at(index)
    end

    level_segments.delete_if do |segment|
      segment.angle <= 0
    end
  end


  class ServerCircle
    attr_reader :x
    attr_reader :y
    attr_reader :radius
    attr_reader :server

    def initialize(x, y, radius, server)
      @x = x
      @y = y
      @radius = radius
      @server = server
    end

    def overlaps(x, y, radius)
      dx = x - @x
      dy = y - @y
      dr = radius + @radius
      dx*dx + dy*dy < dr*dr
    end
  end

  def abs(val)
    if val < 0
      -val
    else
      val
    end
  end

  # Find the intersection of two circles.
  # Translated from this piece of C code: 
  # http://local.wasp.uwa.edu.au/~pbourke/geometry/2circle/tvoght.c
  def circle_circle_intersection(x0, y0, r0,
                                 x1, y1, r1)
    # dx and dy are the vertical and horizontal distances between
    # the circle centers.
    #
    dx = x1 - x0
    dy = y1 - y0

    # Determine the straight-line distance between the centers.
    d = Math.sqrt((dy*dy) + (dx*dx))

    # Check for solvability.
    if (d > (r0 + r1))
      # no solution. circles do not intersect.
      nil

    elsif (d < abs(r0 - r1))
      # no solution. one circle is contained in the other
      return nil

    else

      # 'point 2' is the point where the line through the circle
      # intersection points crosses the line between the circle
      # centers.  

      # Determine the distance from point 0 to point 2.
      a = ((r0*r0) - (r1*r1) + (d*d)) / (2.0 * d)

      # Determine the coordinates of point 2.
      x2 = x0 + (dx * a/d)
      y2 = y0 + (dy * a/d)

      # Determine the distance from point 2 to either of the
      # intersection points.
      h = Math.sqrt((r0*r0) - (a*a))

      # Now determine the offsets of the intersection points from
      # point 2.
      #
      rx = -dy * (h/d)
      ry = dx * (h/d)

      # Determine the absolute intersection points.
      xi = x2 + rx
      xi_prime = x2 - rx
      yi = y2 + ry
      yi_prime = y2 - ry

      [xi, yi, xi_prime, yi_prime]
    end
  end
end

