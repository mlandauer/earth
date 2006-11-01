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
    a = Snapshot.new(directory, stats.clone, snapshots.clone)
  end
  
  def Snapshot.added_files(snap1, snap2)
    added_file_names = snap2.file_names - snap1.file_names
    added_directory_names = snap2.subdirectory_names - snap1.subdirectory_names
    # Directories that have not been either added or removed
    directories = snap2.subdirectory_names - added_directory_names
    
    changes = added_file_names
    added_directory_names.each do |directory|
      changes += Snapshot.added_files(Snapshot.new(directory), snap2.snapshots[directory])
    end
    
    directories.each do |d|
      changes += Snapshot.added_files(snap1.snapshots[d], snap2.snapshots[d])
    end

    changes
  end
  
  def Snapshot.changed_files(snap1, snap2)
    added_file_names = snap2.file_names - snap1.file_names
    added_directory_names = snap2.subdirectory_names - snap1.subdirectory_names
    # Files and directories that haven't been added or removed
    file_names = snap2.file_names - added_file_names
    directory_names = snap2.subdirectory_names - added_directory_names
    
    changes = []
    file_names.each do |f|
      if snap1.stats[f] != snap2.stats[f]
        changes << f
      end
    end
    
    directory_names.each do |d|
      changes += Snapshot.changed_files(snap1.snapshots[d], snap2.snapshots[d])
    end
    
    changes
  end

  def Snapshot.removed_files(snap1, snap2)
    Snapshot.added_files(snap2, snap1)
  end
  
  def initialize(directory, stats = Hash.new, snapshots = Hash.new)
    # Internally store everything as absolute path
    @directory = File.expand_path(directory)
    # These are hashes that map from the name to the properties
    @stats = stats
    @snapshots = snapshots
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
