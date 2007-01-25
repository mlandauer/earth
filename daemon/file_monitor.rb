class FileMonitor
  cattr_accessor :log_all_sql

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

  def FileMonitor.directory_saved(node)
    @directory_eta_printer.increment
  end
  
  def FileMonitor.run_on_new_directory(path, update_time)
    this_server = Earth::Server.this_server
    puts "WARNING: Watching new directory. So, clearing out database"

    benchmark "Database cleanup" do
      # FIXME: Do this in a transaction
      Earth::Directory.delete_all "server_id=#{Earth::Server.this_server.id}"
      this_server.directories.clear      
    end

    directory = benchmark "Scanning and storing tree", false do
    
      directory = this_server.directories.build(:name => File.expand_path(path))
      directory_count = benchmark "Building initial directory structure for #{path}" do
        update(directory, 0, true)
      end

      benchmark "Committing initial directory structure for #{path} to database" do
        @directory_eta_printer = ETAPrinter.new(directory_count)
        Earth::Directory.add_save_observer(self)
        directory.save
        Earth::Directory.remove_save_observer(self)
        @directory_eta_printer = nil
      end

      benchmark "Initial pass at gathering all files beneath #{path}" do
        update(directory, 0, false, true)
      end

      #benchmark "Vacuuming database" do
      #  Earth::File.connection.update("VACUUM FULL ANALYZE")
      #end

      directory
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
      puts "Updating #{directory.server.directories.count} directories..."
      update(directory, update_time)
    end
  end
  
  def FileMonitor.update(directory, update_time = 0, only_build_directories = false, show_eta = false)
    # TODO: Do this in a nicer way
    total_count = 0
    filters = Earth::Filter::find(:all)
    eta_printer = ETAPrinter.new(directory.server.directories.count)
    remaining_count = directory.server.directories.count
    start = Time.new
    directory.each do |d|
      total_count += update_non_recursive(d, filters, only_build_directories)
      total_time = Time.new - start
      remaining_time = update_time - (Time.new - start)
      remaining_count = remaining_count - 1
      if remaining_time > 0 && remaining_count > 0
        sleep (remaining_time / remaining_count)
      end

      if show_eta
        eta_printer.increment
      end
    end
    total_count
  end

  def FileMonitor.update_non_recursive(directory, filters, only_build_directories = false)

    directory_count = 1

    if not only_build_directories
      filter_to_cached_size = directory.filter_to_cached_size(filters)
      filters.each do |filter|
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
      directory_count += update_non_recursive(dir, filters, only_build_directories)
    end

    if not only_build_directories then
      # By adding and removing files on the association, the cache of the association will be kept up to date
      added_file_names = file_names - directory.files.map{|x| x.name}
      added_file_names.each do |name|
        Earth::File.benchmark("Creating file with name #{name}", Logger::DEBUG, !log_all_sql) do
          file = directory.files.create(:name => name, :stat => stats[name])
          filter_to_cached_size.each do |filter, cached_size|
            if filter.matches(file)
              cached_size.recursive_size += file.size
              cached_size.recursive_blocks += file.blocks
            end
          end
          file
        end
      end

      directory.files.each do |file|
        # If the file still exists
        if file_names.include?(file.name)
          # If the file has changed
          if file.stat != stats[file.name]
            filter_to_cached_size.each do |filter, cached_size|
              if filter.matches(file)
                cached_size.recursive_size -= file.size
                cached_size.recursive_blocks -= file.blocks
              end
            end
            file.stat = stats[file.name]
            filter_to_cached_size.each do |filter, cached_size|
              if filter.matches(file)
                cached_size.recursive_size += file.size
                cached_size.recursive_blocks += file.blocks
              end
            end
            Earth::File.benchmark("Updating file with name #{file.name}", Logger::DEBUG, !log_all_sql) do
              file.save
            end
          end
          # If the file has been deleted
        else
          Earth::Directory.benchmark("Removing file with name #{file.name}", Logger::DEBUG, !log_all_sql) do
            filter_to_cached_size.each do |filter, cached_size|
              if filter.matches(file)
                cached_size.recursive_size -= file.size
                cached_size.recursive_blocks -= file.blocks
              end
            end
            directory.files.delete(file)
          end
        end
      end
    end

    directory.children.each do |dir|
      # If the directory has been deleted
      if !subdirectory_names.include?(dir.name)
        Earth::Directory.benchmark("Removing directory with name #{dir.name}", Logger::DEBUG, !log_all_sql) do
          removed_dir_filter_to_cached_size = dir.filter_to_cached_size(filters)
          filter_to_cached_size.each do |filter, cached_size|
            removed_cached_size = removed_dir_filter_to_cached_size[filter]
            if removed_cached_size
              cached_size.recursive_size -= removed_cached_size.recursive_size
              cached_size.recursive_blocks -= removed_cached_size.recursive_blocks
            end
          end
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
          ancestor_filter_to_cached_size = ancestor.filter_to_cached_size(filters)
          filter_to_cached_size.each do |filter, cached_size|
            size_difference, blocks_difference = cached_size.difference
            ancestor_cached_size = ancestor_filter_to_cached_size[filter]
            if not ancestor_cached_size
              ancestor_cached_size = ancestor.cached_sizes.build(:filter => filter)
            end
            ancestor_cached_size.recursive_size += size_difference
            ancestor_cached_size.recursive_blocks += blocks_difference
          end
        end

        filter_to_cached_size.each do |filter, cached_size|
          
          size_difference, blocks_difference = cached_size.difference
          
          if cached_size.new_record?
            cached_size.create
            ancestors_to_update = directory.ancestors
          else
            ancestors_to_update = directory.self_and_ancestors
          end

          if (size_difference != 0 or blocks_difference != 0) and not directory.parent.nil?
            Earth::Directory.benchmark("Updating parent directories' size cache", Logger::DEBUG, !log_all_sql) do
              Earth::CachedSize.update_all("recursive_size = recursive_size + #{size_difference}, recursive_blocks = recursive_blocks + #{blocks_difference}",
                                           "filter_id=#{filter.id} and directory_id in (#{ancestors_to_update.map{|x| x.id}.join(',')})")                
            end
          end
        end
      end
    end
    
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
