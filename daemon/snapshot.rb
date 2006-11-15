# Copyright (C) 2006 Rising Sun Pictures and Matthew Landauer.
# All Rights Reserved.
#  
# This program is free software; you can redistribute it and/or modify it
# under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#
# $Id$

class Snapshot < FileMonitor
  attr_reader :subdirectory_names, :directory, :stats, :subdirectories

  def deep_copy
    Snapshot.new(@observer, @directory, @stats.clone, @subdirectory_names.clone, @subdirectories.clone)
  end
  
  def initialize(observer, directory, stats = Hash.new, subdirectory_names = [], subdirectories = Hash.new)
    super(observer)
    @directory_stat = nil
    @stats = stats
    @subdirectory_names = subdirectory_names
    @directory = directory
    @subdirectories = subdirectories
  end
  
  def update()
    old_snapshot = self.deep_copy
    
    if File.exist?(@directory.path)
      new_stat = File.lstat(@directory.path)
      if new_stat != @directory_stat
        @directory_stat = new_stat
        # Update contents of directory if readable
        if @directory_stat.readable?
          entries = Dir.entries(@directory.path)
          # Ignore all files and directories starting with '.'
          entries.delete_if {|x| x[0,1] == "."}
          
          # TODO: Optimisation - do lstat on all directory entries and use that to determine what is a file
          filenames, @subdirectory_names = entries.partition{|f| File.file?(File.join(@directory.path, f))}
          @stats.clear
          filenames.each {|f| @stats[f] = File.lstat(File.join(@directory.path, f))}
        end
      end
    else
      # Directory has been removed
      @directory_names = []
      @stats.clear
      @directory_stat = nil
      @subdirectories = Hash.new
    end

    Difference.changed_files(old_snapshot, self).each {|x| file_changed(@directory, x, @stats[x])}
    Difference.added_directories(old_snapshot, self).each do |d|
      @subdirectories[d] = directory_added(File.join(directory.path, d))
    end
    Difference.added_files(old_snapshot, self).each {|x| file_added(@directory, x, @stats[x])}
    Difference.removed_files(old_snapshot, self).each {|x| file_removed(@directory, x)}
    Difference.removed_directories(old_snapshot, self).each do |d|
      directory_removed(@subdirectories[d])
      @subdirectories.delete(d)
    end
  end
  
  def file_names
    @stats.keys
  end
end
