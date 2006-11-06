# Copyright (C) 2006 Rising Sun Pictures and Matthew Landauer.
# All Rights Reserved.
#  
# This program is free software; you can redistribute it and/or modify it
# under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#
# $Id$

class Snapshot
  attr_reader :subdirectory_names

  def deep_copy
    Snapshot.new(@stats.clone, @subdirectory_names.clone)
  end
  
  def initialize(stats = Hash.new, subdirectory_names = [])
    @directory_stat = nil
    @stats = stats
    @subdirectory_names = subdirectory_names
  end
  
  def update(directory)
    directory = File.expand_path(directory)
    
    if File.exist?(directory)
      new_stat = File.lstat(directory)
      if new_stat != @directory_stat
        @directory_stat = new_stat
        # Update contents of directory if readable
        if @directory_stat.readable?
          entries = Dir.entries(directory)
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
end

class SnapshotRecursive
  attr_reader :snapshots, :stats

  def initialize(directory = nil)
    # These are hashes that map from the name to the properties
    @stats = Hash.new
    @snapshots = Hash.new

    unless directory.nil?
      # Internally store everything as absolute path
      directory = File.expand_path(directory)
      entries = Dir.entries(directory)
      # Ignore all files and directories starting with '.'
      entries.delete_if {|x| x[0,1] == "."}
  
      # Make absolute paths
      entries.map!{|x| File.join(directory, x)}
      
      filenames, subdirectories = entries.partition{|f| File.file?(f)}
      @stats.clear
      filenames.each do |f|
        @stats[f] = File.lstat(f)
      end
      @snapshots.clear
      subdirectories.each do |d|
        snapshot = SnapshotRecursive.new(d)
        @snapshots[d] = snapshot
      end
    end
  end
  
  def subdirectory_names
    @snapshots.keys
  end
  
  def file_names
    @stats.keys
  end

  # Returns the snapshot object which has a particular file
  # Searches recursively down from here
  # If can't be found returns nil
  def snapshot_with_file(path)
    if file_names.include?(path)
      return self
    else
      @snapshots.each_value do |snapshot|
        s = snapshot.snapshot_with_file(path)
        if !s.nil?
          return s
        end
      end
      nil
    end
  end
  
  def exist?(path)
    !snapshot_with_file(path).nil?
  end
  
  def stat(path)
    snapshot_with_file(path).stats[path]
  end
end

module Difference
  def Difference.added_files(snap1, snap2)
    snap2.file_names - snap1.file_names
  end
    
  def Difference.removed_files(snap1, snap2)
    snap1.file_names - snap2.file_names
  end
  
  # Files that have not been either added or removed
  def Difference.common_files(snap1, snap2)
    snap2.file_names - added_files(snap1, snap2)
  end
  
  def Difference.changed_files(snap1, snap2)
    common_files(snap1, snap2).select {|f| snap1.stat(f) != snap2.stat(f)}
  end
  
  def Difference.changed_files_recursive(snap1, snap2)
    changes = changed_files(snap1, snap2)
    common_directories(snap1, snap2).each do |d|
      changes += changed_files_recursive(snap1.snapshots[d], snap2.snapshots[d])
    end
    changes
  end
  
  def Difference.added_directories(snap1, snap2)
    snap2.subdirectory_names - snap1.subdirectory_names
  end
  
  def Difference.removed_directories(snap1, snap2)
    snap1.subdirectory_names - snap2.subdirectory_names
  end
  
  # Directories that have not been either added or removed
  def Difference.common_directories(snap1, snap2)
    snap2.subdirectory_names - added_directories(snap1, snap2)
  end
  
  def Difference.added_files_recursive(snap1, snap2)
    changes = added_files(snap1, snap2)
    added_directories(snap1, snap2).each do |directory|
      changes += added_files_recursive(SnapshotRecursive.new, snap2.snapshots[directory])
    end
    common_directories(snap1, snap2).each do |d|
      changes += added_files_recursive(snap1.snapshots[d], snap2.snapshots[d])
    end
    changes
  end
    
  def Difference.removed_files_recursive(snap1, snap2)
    added_files_recursive(snap2, snap1)
  end
end
