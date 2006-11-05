class SnapshotNonRecursive
  attr_reader :directory_stat, :directory, :subdirectory_names

  def deep_copy
    SnapshotNonRecursive.new(@directory, @stats.clone, @subdirectory_names.clone)
  end
  
  def initialize(directory, stats = Hash.new, subdirectory_names = [])
    @directory = File.expand_path(directory)
    @directory_stat = nil
    @stats = stats
    @subdirectory_names = subdirectory_names
  end
  
  def update
    if File.exist?(@directory)
      new_stat = File.lstat(@directory)
      if new_stat != @directory_stat
        @directory_stat = new_stat
        # Update contents of directory if readable
        if @directory_stat.readable?
          entries = Dir.entries(@directory)
          # Ignore all files and directories starting with '.'
          entries.delete_if {|x| x[0,1] == "."}
          # Make absolute paths
          entries.map!{|x| File.join(directory, x)}
          
          filenames, @subdirectory_names = entries.partition{|f| File.file?(f)}
          @stats.clear
          filenames.each do |f|
            @stats[f] = File.lstat(f)
          end
        end
      end
    else
      # Directory has been removed
      @directory_names = []
      @stats.clear
      @directory_stat = nil
    end
  end
  
  def stat(path)
    @stats[path]
  end
  
  def file_names
    @stats.keys
  end

  def SnapshotNonRecursive.added_files(snap1, snap2)
    snap2.file_names - snap1.file_names
  end
  
  def SnapshotNonRecursive.removed_files(snap1, snap2)
    snap1.file_names - snap2.file_names
  end
  
  def SnapshotNonRecursive.changed_files(snap1, snap2)
    added_file_names = snap2.file_names - snap1.file_names
    # Files that haven't been added or removed
    file_names = snap2.file_names - added_file_names
    
    changes = []
    file_names.each do |f|
      if snap1.stat(f) != snap2.stat(f)
        changes << f
      end
    end
    
    changes
  end

  def SnapshotNonRecursive.added_directories(snap1, snap2)
    snap2.subdirectory_names - snap1.subdirectory_names
  end

  def SnapshotNonRecursive.removed_directories(snap1, snap2)
    snap1.subdirectory_names - snap2.subdirectory_names
  end
end

class PosixFileMonitor < FileMonitorBase
  def initialize(directory)
    @directory = directory
    @snapshots = Hash.new
    @snapshots[directory] = SnapshotNonRecursive.new(directory)
  end
  
  def remove_directory(directory)
    #puts "Removing directory #{directory}"
    # First remove subdirectories
    @snapshots[directory].subdirectory_names.each {|x| remove_directory(x)}
    @snapshots[directory].file_names.each {|x| file_removed(x)}
    @snapshots.delete(directory)
  end
  
  def add_directory(directory)
    snapshot = SnapshotNonRecursive.new(directory)
    @snapshots[directory] = snapshot
    old_snapshot = snapshot.deep_copy
    snapshot.update

    SnapshotNonRecursive.added_files(old_snapshot, snapshot).each {|x| file_added(x, snapshot.stat(x))}
    SnapshotNonRecursive.added_directories(old_snapshot, snapshot).each {|x| add_directory(x)}
  end
  
  def update
    added_directories = []
    removed_directories = []
    
    @snapshots.each do |directory, snapshot|
      old_snapshot = snapshot.deep_copy
      snapshot.update

      added_directories += SnapshotNonRecursive.added_directories(old_snapshot, snapshot)
      removed_directories += SnapshotNonRecursive.removed_directories(old_snapshot, snapshot)
      
      SnapshotNonRecursive.added_files(old_snapshot, snapshot).each {|x| file_added(x, snapshot.stat(x))}
      SnapshotNonRecursive.removed_files(old_snapshot, snapshot).each {|x| file_removed(x)}
      SnapshotNonRecursive.changed_files(old_snapshot, snapshot).each {|x| file_changed(x, snapshot.stat(x))}
    end
    
    # Doing this outside the loop above so that we are not adding and removing from @snapshots
    # while we're in the middle of the loop
    added_directories.each {|x| add_directory(x)}
    removed_directories.each {|x| remove_directory(x)}
  end
end
