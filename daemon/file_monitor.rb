class FileMonitor
  cattr_accessor :log_all_sql
  
  # Set this to true if you want to see the individual SQL commands
  self.log_all_sql = false
  
  def FileMonitor.benchmark(description)
    time_before = Time.new
    yield
    duration = Time.new - time_before
    puts "#{description} took #{duration}s"
    duration
  end
  
  def FileMonitor.run_on_new_directory(path, update_time)
    this_server = Earth::Server.this_server
    puts "WARNING: Watching new directory. So, clearing out database"

    benchmark "Database cleanup" do
      # Workaround until on delete cascade is properly supported by faster_nested_set.  -->
      # FIXME: The following line unconditionally uses PostgreSQL extensions
      # Provide an alternative which uses a sub-select
      # FIXME: Do this in a transaction
      Earth::File.connection.delete("DELETE FROM #{Earth::File.table_name} USING #{Earth::Directory.table_name} WHERE #{Earth::Directory.table_name}.server_id=#{Earth::Server.this_server.id} AND #{Earth::Directory.table_name}.id = #{Earth::File.table_name}.directory_id", "Earth::Directory Delete all")
      Earth::Directory.connection.delete("DELETE FROM #{Earth::Directory.table_name} WHERE server_id=#{Earth::Server.this_server.id}", "Earth::Directory Delete all")
      # <--    
      this_server.directories.clear      
    end
    
    directory = this_server.directories.build(:name => File.expand_path(path))
    initial_build_duration = benchmark "Building initial directory structure for #{path}" do
      update(directory, :only_build_directories => true)
    end
    
    initial_commit_duration = benchmark "Committing initial directory structure for #{path} to database" do
      directory.save
    end
    
    initial_update_duration = benchmark "Initial pass at gathering all files beneath #{path}" do
      update(directory)
    end
    
    puts "Scanning and storing tree took #{initial_build_duration + initial_commit_duration + initial_update_duration}s"

    #benchmark "Vacuuming database" do
    #  Earth::File.connection.update("VACUUM FULL ANALYZE")
    #end
    
    benchmark "Scanning and storing tree" do
      update(directory)
    end
    
    run(directory, update_time)
  end
  
  def FileMonitor.run_on_existing_directory(update_time)
    directories = Earth::Directory.roots_for_server(Earth::Server.this_server)
    raise "Watch directory is not set for this server" if directories.empty?
    raise "Currently not properly supporting multiple watch directories" if directories.size > 1
    directory = directories[0]
    puts "Collecting startup data from database..."
    directory.load_all_children
    run(directory, update_time)
  end
  
private

  def FileMonitor.run(directory, update_time)
    puts "Watching directory #{directory.path}"
    
    while true do
      puts "Updating #{directory.recursive_file_count} directories..."
      update(directory)
      puts "Sleeping for #{update_time} seconds..."
      sleep(update_time)
    end
  end
  
  def FileMonitor.update(directory, only_build_directories = false)
    directory.each do |d|
      update_non_recursive(d, only_build_directories)
    end
  end

  def FileMonitor.update_non_recursive(directory, only_build_directories = false)

    # TODO: remove exist? call as it is an extra filesystem access
    if File.exist?(directory.path)
      new_directory_stat = File.lstat(directory.path)
    else
      new_directory_stat = nil
    end
    
    # If directory hasn't changed then return
    if new_directory_stat == directory.stat
      return
    end

    file_names, subdirectory_names, stats = [], [], Hash.new
    if new_directory_stat && new_directory_stat.readable? && new_directory_stat.executable?
      file_names, subdirectory_names, stats = contents(directory)
    end

    added_directory_names = subdirectory_names - directory.children.map{|x| x.name}
    added_directory_names.each do |name|
      dir = Earth::Directory.benchmark("Creating directory with name #{directory.name}/#{name}", Logger::DEBUG, !log_all_sql) do
        attributes = { :name => name, :server_id => directory.server_id }
        if only_build_directories then
          directory.children.build(attributes)
        else
          directory.children.create(attributes)
        end
      end
      update_non_recursive(dir, only_build_directories)
    end

    if not only_build_directories then
      # By adding and removing files on the association, the cache of the association will be kept up to date
      added_file_names = file_names - directory.files.map{|x| x.name}
      added_file_names.each do |name|
        Earth::File.benchmark("Creating file with name #{name}", Logger::DEBUG, !log_all_sql) do
          directory.files.create(:name => name, :stat => stats[name])
        end
      end

      directory.files.each do |file|
        # If the file still exists
        if file_names.include?(file.name)
          # If the file has changed
          if file.stat != stats[file.name]
            file.stat = stats[file.name]
            Earth::File.benchmark("Updating file with name #{file.name}", Logger::DEBUG, !log_all_sql) do
              file.save
            end
          end
          # If the file has been deleted
        else
          Earth::Directory.benchmark("Removing file with name #{file.name}", Logger::DEBUG, !log_all_sql) do
            directory.files.delete(file)
          end
        end
      end
    end

    directory.children.each do |dir|
      # If the directory has been deleted
      if !subdirectory_names.include?(dir.name)
        Earth::Directory.benchmark("Removing directory with name #{dir.name}", Logger::DEBUG, !log_all_sql) do
          directory.child_delete(dir)
        end
      end
    end
    
    # Update the directory stat information at the end
    if not only_build_directories then
      if File.exist?(directory.path)
        directory.stat = new_directory_stat
        # This will not overwrite 'lft' and 'rgt' so it doesn't matter if these are out of date
        Earth::Directory.benchmark("Updating directory with name #{directory.name}", Logger::DEBUG, !log_all_sql) do
          directory.update
        end
      end
    end
    
    # Removes the files in this directory from the cache (so that they don't take up memory)
    # However, they will get reloaded automatically from the database the next time this
    # directory changes
    directory.files.reset
  end

  def FileMonitor.contents(directory)
    entries = Dir.entries(directory.path)
    # Ignore ".' and ".." directories
    entries.delete(".")
    entries.delete("..")
    
    # Contains the stat information for both files and directories
    stats = Hash.new
    entries.each {|x| stats[x] = File.lstat(File.join(directory.path, x))}
  
    # Seperately test for whether it's a file or a directory because it could
    # be something like a symbolic link (which we shouldn't follow)
    file_names = entries.select{|x| stats[x].file?}
    subdirectory_names = entries.select{|x| stats[x].directory?}
    
    return file_names, subdirectory_names, stats
  end
end
