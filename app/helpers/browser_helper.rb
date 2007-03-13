module BrowserHelper

  LINKED_FILE_PATH_SHOW_PARENT_LINK = false
  LINKED_FILE_PATH_SHOW_CURRENT     = false

  def linked_file_path(file)
    html = ""
    if not @server
      # On root level
      html = "root::" if LINKED_FILE_PATH_SHOW_CURRENT
      html += link_to(file.directory.server.name, 
                      :overwrite_params => {:page => nil, 
                                            :server => file.directory.server.name, 
                                            :path => nil})
      html += ":"
    elsif @server and not @directory
      # On server level
      if LINKED_FILE_PATH_SHOW_PARENT_LINK
        html = link_to("root", 
                       :overwrite_params => {:page => nil, 
                                             :path => nil, 
                                             :server => nil})
        html += "::"
      end
      if LINKED_FILE_PATH_SHOW_CURRENT
        html += h(@server.name)
        html += ":"
      end
    elsif @directory and not @directory.parent_id
      # On top directory level
      if LINKED_FILE_PATH_SHOW_PARENT_LINK
        html = link_to("..", 
                       :overwrite_params => {:page => nil, 
                                             :path => nil})
        html += ":"
      end
    else
      # On deeper directory level
      if LINKED_FILE_PATH_SHOW_PARENT_LINK
        html = link_to("..", 
                       :overwrite_params => {:page => nil, 
                                             :path => @directory.parent.path})
      end
    end
    self_and_ancestors_up_to(file.directory, @directory).reverse.each do |parent| 
      if parent == @directory
        if LINKED_FILE_PATH_SHOW_CURRENT
          html += h(parent.name.gsub(/ /, "&nbsp;"))
          html += "/<wbr/>"
        end
      else 
        html += link_to(parent.name.gsub(/ /, "&nbsp;"), 
                        :overwrite_params => {:page => nil, 
                                              :server => file.directory.server.name,  
                                              :path => parent.path})
        html += "/<wbr/>"
      end
    end
    html
  end
end
