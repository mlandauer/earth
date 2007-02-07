class FileMonitor
  cattr_accessor :log_all_sql
  cattr_accessor :console_writer

  class ETAPrinter
    def initialize(number_of_items)
      @number_of_items = number_of_items
      @items_completed = 0
      @longest_output = 0
      @last_eta_update = 0
      @min_eta_update_delta = 1.seconds
      @start = Time.new
    end

    def increment()
      @items_completed += 1
      now = Time.new
      time_per_item = (now - @start) / @items_completed
      items_remaining = @number_of_items - @items_completed
      if items_remaining > 0
        if @last_eta_update.to_i + @min_eta_update_delta <= now.to_i
          @last_eta_update = now
          time_remaining = items_remaining * time_per_item
          eta_string = "ETA: #{(Time.local(2007) + (time_remaining)).strftime('%H:%M:%S')}s"
          print(eta_string + "\010" * eta_string.size)
          $stdout.flush
          @longest_output = [@longest_output, eta_string.size].max
        end
      else
        print(" " * @longest_output + "\010" * @longest_output)
      end
    end
  end
  
  # Set this to true if you want to see the individual SQL commands
  self.log_all_sql = false
  
  def FileMonitor.start(path, only_initial_update = false)
    # Find the current directory that it's watching
    directories = Earth::Directory.roots_for_server(Earth::Server.this_server)
    if directories.empty?
      directory = nil
    elsif directories.size == 1
      directory = directories[0]
    else
      raise "Currently not properly supporting multiple watch directories"
    end
    
    start_heartbeat_thread
    
    # If the database has been cleared
    if directory.nil?
      directory = FileMonitor.initial_pass_on_new_directory(File.expand_path(path))  
    # If we're watching the same directory as before
    elsif File.expand_path(path) == directory.path
      benchmark "Collecting startup data from database" do
        directory.load_all_children
      end
    else
      raise "Clear out the database (with --clear) before running on a new directory"
    end
    
    run(directory) unless only_initial_update
  end
  
  def FileMonitor.directory_saved(node)
    @directory_eta_printer.increment
  end
  
  # Remove all directories on this server from the database
  def FileMonitor.database_cleanup
    this_server = Earth::Server.this_server
    benchmark "Clearing old data for this server out of the database" do
      Earth::Directory.delete_all "server_id=#{this_server.id}"
    end  
  end
  
private

  def FileMonitor.benchmark(description = nil, show_pending = true)
    if description and show_pending
      print "#{description} ... "
      $stdout.flush
    end
    time_before = Time.new
    result = yield
    duration = Time.new - time_before
    if description
      if not show_pending
        print "#{description} "
      end
      puts "took #{duration}s"
    end
    result
  end

  def FileMonitor.start_heartbeat_thread
    ActiveRecord::Base.allow_concurrency = true
    puts "Starting heartbeat thread..."
    Thread.new do
      while true do
        # reload the server object in case of changes on the database side
        server = Earth::Server.this_server
        $stdout.flush
        server.heartbeat
        sleep(server.heartbeat_interval)
      end
    end
  end
  
  def FileMonitor.initial_pass_on_new_directory(path)
    this_server = Earth::Server.this_server

    benchmark "Scanning and storing tree", false do
    
      directory = this_server.directories.build(:name => path, :path => path)
      directory_count = benchmark "Building initial directory structure for #{path}" do
        update(directory, 0, true, false, false)
      end

      benchmark "Committing initial directory structure for #{path} to database" do
        @directory_eta_printer = ETAPrinter.new(directory_count)
        Earth::Directory.add_save_observer(self)
        directory.save
        Earth::Directory.remove_save_observer(self)
        @directory_eta_printer = nil
      end

      directory.reload
      directory.load_all_children(0, :include => :cached_sizes)

      benchmark "Initial pass at gathering all files beneath #{path}" do
        update(directory, 0, false, true, true)
      end

      benchmark "Saving cache information" do
        @cached_size_eta_printer = ETAPrinter.new(directory_count)
        save_cached_sizes(directory)
        @cached_size_eta_printer = nil
      end

      #benchmark "Vacuuming database" do
      #  Earth::File.connection.update("VACUUM FULL ANALYZE")
      #end

      directory
    end
  end

  def FileMonitor.save_cached_sizes(directory)

    directory.cached_sizes.each do |cached_size|
      cached_size.create
    end
    
    @cached_size_eta_printer.increment
    
    directory.children.each do |child|
      save_cached_sizes(child)
    end
  end
  
  def FileMonitor.run(directory)
    while true do
      # At the beginning of every update get the server information in case it changes on the database
      server = Earth::Server.this_server
      update_time = server.update_interval
      puts "Updating #{directory.server.directories.count} directories over #{update_time}s..."
      update(directory, update_time)      
    end
  end
  
  def FileMonitor.update(directory, update_time = 0, 
                         only_build_directories = false, 
                         initial_pass = false, 
                         show_eta = false)
    # TODO: Do this in a nicer way
    total_count = 0
    filters = Earth::Filter::find(:all)
    id_to_filters = {}
    filters.each do |filter|
      id_to_filters[filter.id] = filter
    end
    eta_printer = ETAPrinter.new(directory.server.directories.count)
    remaining_count = directory.server.directories.count
    start = Time.new
    directory.each do |d|
      total_count += update_non_recursive(d, id_to_filters, only_build_directories, initial_pass)
      remaining_time = update_time - (Time.new - start)
      remaining_count = remaining_count - 1
      if remaining_time > 0 && remaining_count > 0
        sleep (remaining_time / remaining_count)
      end

      if show_eta
        eta_printer.increment
      end
    end
    # Set the last_update_finish_time
    server = Earth::Server.this_server
    server.last_update_finish_time = Time.new
    server.save!
    
    total_count
  end

  def FileMonitor.update_non_recursive(directory, id_to_filters, 
                                       only_build_directories = false, initial_pass = false)

    directory_count = 1

    if not only_build_directories
      filter_to_cached_size = directory.filter_to_cached_size(id_to_filters)
      id_to_filters.each do |filter_id,filter|
        if not filter_to_cached_size.has_key?(filter)
          filter_to_cached_size[filter] = directory.cached_sizes.build(:filter => filter)
        end
      end
      filter_to_cached_size.each do |filter, cached_size|
        cached_size.snapshot
      end
    end

    # TODO: remove exist? call as it is an extra filesystem access
    if File.exist?(directory.path)
      new_directory_stat = File.lstat(directory.path)
    else
      new_directory_stat = nil
    end
    
    # If directory hasn't changed then return
    if new_directory_stat == directory.stat
      return 1
    end

    #Earth::Directory::transaction do

      file_names, subdirectory_names, stats = [], [], Hash.new
      if new_directory_stat && new_directory_stat.readable? && new_directory_stat.executable?
        file_names, subdirectory_names, stats = contents(directory)
      end

      if not initial_pass
        added_directory_names = subdirectory_names - directory.children.map{|x| x.name}
        added_directory_names.each do |name|
          dir = Earth::Directory.benchmark("Creating directory #{directory.path}/#{name}", Logger::DEBUG, !log_all_sql) do
            attributes = { :name => name, :path => "#{directory.path}/#{name}", :server_id => directory.server_id }
            if only_build_directories then
              directory.children.build(attributes)
            else
              #directory.reload # FIXME
              directory.children.create(attributes)
            end
          end
          update_non_recursive(dir, id_to_filters, only_build_directories, initial_pass)
        end
      end

      if not only_build_directories then
        # By adding and removing files on the association, the cache of the association will be kept up to date
        if not initial_pass
          added_file_names = file_names - directory.files.map{|x| x.name}
        else
          added_file_names = file_names
        end
        added_file_names.each do |name|
          Earth::File.benchmark("Creating file with name #{name}", Logger::DEBUG, !log_all_sql) do
            file = directory.files.create(:name => name, :path => (directory.path + "/" + name), :stat => stats[name])
            filter_to_cached_size.each do |filter, cached_size|
              cached_size.increment(file) if filter.matches(file)
            end
            file
          end
        end

        if not initial_pass
          directory.files.each do |file|
            # If the file still exists
            if file_names.include?(file.name)
              # If the file has changed
              if file.stat != stats[file.name]
                filter_to_cached_size.each do |filter, cached_size|
                  cached_size.decrement(file) if filter.matches(file)
                end
                file.stat = stats[file.name]
                filter_to_cached_size.each do |filter, cached_size|
                  cached_size.increment(file) if filter.matches(file)
                end
                Earth::File.benchmark("Updating file with name #{file.name}", Logger::DEBUG, !log_all_sql) do
                  file.save
                end
              end
              # If the file has been deleted
            else
              Earth::Directory.benchmark("Removing file with name #{file.name}", Logger::DEBUG, !log_all_sql) do
                filter_to_cached_size.each do |filter, cached_size|
                  cached_size.decrement(file) if filter.matches(file)
                end
                directory.files.delete(file)
              end
            end
          end
        end
      end

      directory.children.each do |dir|
        # If the directory has been deleted
        if !subdirectory_names.include?(dir.name)
          Earth::Directory.benchmark("Removing directory with name #{dir.name}", Logger::DEBUG, !log_all_sql) do
            removed_dir_filter_to_cached_size = dir.filter_to_cached_size(id_to_filters)
            filter_to_cached_size.each do |filter, cached_size|
              removed_cached_size = removed_dir_filter_to_cached_size[filter]
              cached_size.decrement(removed_cached_size) if removed_cached_size
            end
            #directory.reload # FIXME
            directory.child_delete(dir)
          end
        end
      end
      
      # Update the directory stat information at the end
      if not only_build_directories
        if File.exist?(directory.path) # FIXME - why is this checked again? can this lead to database inconsistency wrt recursive sizes?
          directory.stat = new_directory_stat

          # This will not overwrite 'lft' and 'rgt' so it doesn't matter if these are out of date
          Earth::Directory.benchmark("Updating directory with name #{directory.name}", Logger::DEBUG, !log_all_sql) do
            directory.update
          end

          directory.ancestors.each do |ancestor|
            ancestor_filter_to_cached_size = ancestor.filter_to_cached_size(id_to_filters)
            filter_to_cached_size.each do |filter, cached_size|
              size_difference, blocks_difference, count_difference = cached_size.difference
              ancestor_cached_size = ancestor_filter_to_cached_size[filter]
              if not ancestor_cached_size
                ancestor_cached_size = ancestor.cached_sizes.build(:filter => filter)
              end
              ancestor_cached_size.size += size_difference
              ancestor_cached_size.blocks += blocks_difference
              ancestor_cached_size.count += count_difference
            end
          end

          if not initial_pass
            filter_to_cached_size.each do |filter, cached_size|
              
              size_difference, blocks_difference, count_difference = cached_size.difference
              
              if cached_size.new_record?
                cached_size.create
                ancestors_to_update = directory.ancestors
              else
                ancestors_to_update = directory.self_and_ancestors
              end

              if (size_difference != 0 or blocks_difference != 0 or count_difference != 0) and not directory.parent.nil?
                Earth::Directory.benchmark("Updating parent directories' size cache", Logger::DEBUG, false) do ##!log_all_sql) do
                  Earth::CachedSize.update_all("size = size + #{size_difference}, blocks = blocks + #{blocks_difference}, count = count + #{count_difference}",
                                               "filter_id=#{filter.id} and directory_id in (#{ancestors_to_update.map{|x| x.id}.join(',')})")                
                end
              end
            end
          end
        end
      end
    #end
    
    # Removes the files in this directory from the cache (so that they don't take up memory)
    # However, they will get reloaded automatically from the database the next time this
    # directory changes
    directory.files.reset

    directory_count
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
