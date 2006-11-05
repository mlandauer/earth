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
        # Update contents of directory
        entries = Dir.entries(@directory)
        entries.delete(".")
        entries.delete("..")
    
        # Make absolute paths
        entries.map!{|x| File.join(directory, x)}
        
        filenames, @subdirectory_names = entries.partition{|f| File.file?(f)}
        @stats.clear
        filenames.each do |f|
          @stats[f] = File.lstat(f)
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
    puts "Removing directory #{directory}"
    # First remove subdirectories
    @snapshots[directory].subdirectory_names.each {|x| remove_directory(x)}
    @snapshots[directory].file_names.each {|x| file_removed(x)}
    @snapshots.delete(directory)
  end
  
  def update
    @snapshots.each do |directory, snapshot|
      old_snapshot = snapshot.deep_copy
      snapshot.update
      added_files = SnapshotNonRecursive.added_files(old_snapshot, snapshot)
      added_directories = SnapshotNonRecursive.added_directories(old_snapshot, snapshot)
      removed_files = SnapshotNonRecursive.removed_files(old_snapshot, snapshot)
      removed_directories = SnapshotNonRecursive.removed_directories(old_snapshot, snapshot)

      added_files.each {|x| file_added(x, snapshot.stat(x))}
      for added_directory in added_directories
        @snapshots[added_directory] = SnapshotNonRecursive.new(added_directory)
      end
      removed_files.each {|x| file_removed(x)}
      for removed_directory in removed_directories
        remove_directory(removed_directory)
      end
    end
  end
end
