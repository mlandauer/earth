require 'thread'

FileAdded = Struct.new(:filename)
FileRemoved = Struct.new(:filename)

class Snapshot
  attr_reader :directory, :filenames, :snapshots

  def deep_copy
    a = Snapshot.new(directory, filenames, snapshots.clone)
  end
  
  def Snapshot.added_files(snap1, snap2)
    added_files = snap2.filenames - snap1.filenames
    added_directories = snap2.subdirectories - snap1.subdirectories
    # Directories that have not been either added or removed
    directories = snap2.subdirectories - added_directories
    
    changes = added_files
    added_directories.each do |directory|
      changes += Snapshot.added_files(Snapshot.new(directory), snap2.snapshots[directory])
    end
    
    directories.each do |d|
      changes += Snapshot.added_files(snap1.snapshots[d], snap2.snapshots[d])
    end

    changes
  end
  
  def Snapshot.removed_files(snap1, snap2)
    Snapshot.added_files(snap2, snap1)
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
    Snapshot.added_files(old_snapshot, @snapshot).each {|x| @queue.push(FileAdded.new(x))}
    Snapshot.removed_files(old_snapshot, @snapshot).each {|x| @queue.push(FileRemoved.new(x))}
  end
end
