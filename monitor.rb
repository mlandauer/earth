FileAdded = Struct.new(:filename)
FileRemoved = Struct.new(:filename)
DirectoryAdded = Struct.new(:path)
DirectoryRemoved = Struct.new(:path)

class Snapshot
  attr_reader :directory, :filenames, :subdirectories, :snapshots

  def deep_copy
    a = Snapshot.new(directory, filenames, snapshots.clone)
  end
  
  def Snapshot.difference(snap1, snap2)
    added_files = snap2.filenames - snap1.filenames
    removed_files = snap1.filenames - snap2.filenames
    added_directories = snap2.snapshots.keys - snap1.snapshots.keys
    removed_directories = snap1.snapshots.keys - snap2.snapshots.keys

    changes = added_files.map{|x| FileAdded.new(x)}
    changes += removed_files.map{|x| FileRemoved.new(x)}
    changes += added_directories.map{|x| DirectoryAdded.new(x)}
    changes += removed_directories.map{|x| DirectoryRemoved.new(x)}
    # In each of the added directories all the files are new files
    added_directories.each do |directory|
      changes += Snapshot.difference(Snapshot.new(directory), snap2.snapshots[directory])
    end
    removed_directories.each do |directory|
      changes += Snapshot.difference(snap1.snapshots[directory], Snapshot.new(directory))
    end
    
    changes
  end

  def initialize(directory, filenames = [], snapshots = Hash.new)
    @directory = directory
    @filenames = filenames
    @snapshots = snapshots
  end
  
  def exist?(path)
    if @filenames.include?(path)
      true
    else
      @snapshots.each_value do |snapshot|
        if snapshot.exist?(path)
          return true
        end
      end
      false
    end
  end
  
  def update
    entries = Dir.entries(@directory)
    entries.delete(".")
    entries.delete("..")

    # Make absolute paths
    entries.map!{|x| File.join(@directory, x)}
    
    @filenames, subdirectories = entries.partition{|f| File.file?(f)}
    @snapshots.clear
    subdirectories.each do |d|
      snapshot = Snapshot.new(d)
      snapshot.update
      @snapshots[d] = snapshot
    end
  end
end

class Monitor
  def initialize(directory)
    @snapshot = Snapshot.new(directory)
  end
  
  def exist?(path)
    @snapshot.exist?(path)
  end
  
  def update
    old_snapshot = @snapshot.deep_copy
    @snapshot.update
    # Return the changes
    Snapshot.difference(old_snapshot, @snapshot)
  end
end
