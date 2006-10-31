require 'thread'

FileAdded = Struct.new(:filename)
FileRemoved = Struct.new(:filename)

class Snapshot
  attr_reader :directory, :filenames, :snapshots

  def deep_copy
    a = Snapshot.new(directory, filenames, snapshots.clone)
  end
  
  def Snapshot.difference(snap1, snap2)
    added_files = snap2.filenames - snap1.filenames
    removed_files = snap1.filenames - snap2.filenames
    added_directories = snap2.subdirectories - snap1.subdirectories
    removed_directories = snap1.subdirectories - snap2.subdirectories
    # Directories that have not been either added or removed
    directories = snap1.subdirectories - removed_directories
    
    changes = added_files.map{|x| FileAdded.new(x)}
    changes += removed_files.map{|x| FileRemoved.new(x)}
    directories.each do |d|
      changes += Snapshot.difference(snap1.snapshots[d], snap2.snapshots[d])
    end
    
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
  
  def subdirectories
    @snapshots.keys
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
  attr_reader :queue
  
  def initialize(directory)
    @snapshot = Snapshot.new(directory)
    @queue = Queue.new
  end
  
  def exist?(path)
    @snapshot.exist?(path)
  end
  
  def update
    old_snapshot = @snapshot.deep_copy
    @snapshot.update
    # Pop the changes onto the queue
    Snapshot.difference(old_snapshot, @snapshot).each {|x| @queue.push(x)}
  end
end
