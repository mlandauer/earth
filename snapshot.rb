# Copyright (C) 2006 Rising Sun Pictures and Matthew Landauer.
# All Rights Reserved.
#  
# This program is free software; you can redistribute it and/or modify it
# under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#
# $Id$

class Snapshot
  attr_reader :directory, :snapshots, :stats

  def deep_copy
    a = Snapshot.new(directory, filenames, stats.clone, snapshots.clone)
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
  
  def initialize(directory, filenames = [], stats = Hash.new, snapshots = Hash.new)
    # Internally store everything as absolute path
    @directory = File.expand_path(directory)
    # These are hashes that map from the name to the properties
    @stats = stats
    @snapshots = snapshots
  end
  
  def subdirectories
    @snapshots.keys
  end
  
  def filenames
    @stats.keys
  end

  # Returns the snapshot object which has a particular file
  # Searches recursively down from here
  # If can't be found returns nil
  def snapshot_with_file(path)
    if filenames.include?(path)
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
  
  def update
    entries = Dir.entries(@directory)
    entries.delete(".")
    entries.delete("..")

    # Make absolute paths
    entries.map!{|x| File.join(@directory, x)}
    
    filenames, subdirectories = entries.partition{|f| File.file?(f)}
    @stats.clear
    filenames.each do |f|
      @stats[f] = File.lstat(f)
    end
    @snapshots.clear
    subdirectories.each do |d|
      snapshot = Snapshot.new(d)
      snapshot.update
      @snapshots[d] = snapshot
    end
  end
end
