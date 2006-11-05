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
  
  def SnapshotNonRecursive.added_directories(snap1, snap2)
    snap2.subdirectory_names - snap1.subdirectory_names
  end
end

class PosixFileMonitor < FileMonitorBase
  def initialize(directory)
    @directory = directory
    @snapshots = [SnapshotNonRecursive.new(directory)]
  end
  
  def update
    # Get the stat information of all the directories from the current snapshot
    # and find the directories which have different stat info now
    for snapshot in @snapshots
      old_snapshot = snapshot.deep_copy
      snapshot.update
      SnapshotNonRecursive.added_files(old_snapshot, snapshot).each {|x| file_added(x, snapshot.stat(x))}
      for added_directory in SnapshotNonRecursive.added_directories(old_snapshot, snapshot)
        @snapshots << SnapshotNonRecursive.new(added_directory)
      end
    end
  end
end
