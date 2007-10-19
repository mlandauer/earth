module Earth
  def self.filter_context(server,directory,params={})
    
    show_empty = params[:show_empty]
    show_hidden = params[:show_hidden]
    
    any_empty  = false
    any_hidden = false
    
    Earth::File.with_filter(params) do

      # if at the root
      if !server
        servers = Earth::Server.find(:all)
        servers_and_bytes,any_empty = Earth::Server.filter_and_add_bytes(servers, :show_empty => show_empty)
        
      # if at the root of a server
      elsif !directory
        directories = Earth::Directory.roots_for_server(server)
          
      # if in a directory
      else
        directories = directory.children
          
        # Scoping appears to not work on associations so doing the find explicitly
        files = Earth::File.find(:all, :conditions => ['directory_id = ?', directory.id])
        filtered_files, any_empty_files, any_hidden_files = Earth::File.filter(files, :show_hidden => show_hidden)

        any_empty  ||= any_empty_files
        any_hidden ||= any_hidden_files
      end
      
      # Filter out servers and directories that have no files, query sizes
      if directories
        directories_and_bytes,any_empty_dirs,any_hidden_dirs = Earth::Directory.filter_and_add_bytes(directories, :show_empty => show_empty, :show_hidden => show_hidden)
        
        any_empty  ||= any_empty_dirs
        any_hidden ||= any_hidden_dirs
      end
      
      
      [servers_and_bytes, directories_and_bytes, filtered_files, any_empty, any_hidden]
    end
  end
end