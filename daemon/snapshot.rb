# Copyright (C) 2006 Rising Sun Pictures and Matthew Landauer.
# All Rights Reserved.
#  
# This program is free software; you can redistribute it and/or modify it
# under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#
# $Id$

class Snapshot < FileMonitor
  attr_reader :directory, :subdirectories

  def initialize(directory, observer)
    super(observer)
    @directory = directory
    @subdirectories = Hash.new
    @subdirectory_names = []
    @directory.children.each do |x|
      @subdirectories[x.name] = x
      @subdirectory_names << x.name
    end
    @files = Hash.new
    @file_names = []
    @directory.file_info.each do |x|
      @files[x.name] = x
      @file_names << x.name
    end
    @directory_stat = directory.stat
    @stats = Hash.new
  end
  
  def update
    old_file_names = @file_names.clone
    old_subdirectory_names = @subdirectory_names.clone
    old_stats = @stats.clone
    old_directory_stat = @directory_stat
    
    update_contents

    changed_file_names = (old_file_names & @file_names).reject {|x| old_stats[x] == @stats[x]}
    added_file_names = @file_names - old_file_names
    removed_file_names = old_file_names - @file_names
    added_directory_names = @subdirectory_names - old_subdirectory_names
    removed_directory_names = old_subdirectory_names - @subdirectory_names

    changed_file_names.each {|x| file_changed(@files[x], @stats[x])}
    added_directory_names.each {|x| @subdirectories[x] = directory_added(@directory, x)}
    added_file_names.each {|x| @files[x] = file_added(@directory, x, @stats[x])}
    removed_file_names.each do |x|
      file_removed(@files[x])
      @files.delete(x)
    end
    removed_directory_names.each do |x|
      directory_removed(@subdirectories[x])
      @subdirectories.delete(x)
    end
    
    # Send the directory_changed message right at the end
    if @directory_stat != old_directory_stat && File.exist?(@directory.path)
      directory_changed(@directory, @directory_stat)
    end
  end

private

  def actual_update_contents
    entries = Dir.entries(@directory.path)
    # Ignore all files and directories starting with '.'
    entries.delete_if {|x| x[0,1] == "."}
    
    # Contains the stat information for both files and directories
    @stats.clear
    entries.each {|x| @stats[x] = File.lstat(File.join(@directory.path, x))}
  
    @file_names, @subdirectory_names = entries.partition{|x| @stats[x].file?}
  end
  
  def update_contents
    # TODO: remove exist? call as it is an extra filesystem access
    if File.exist?(@directory.path)
      new_stat = File.lstat(@directory.path)
      # Update contents if something has changed and directory is readable
      if new_stat.mtime != @directory_stat.mtime && new_stat.readable?
        actual_update_contents
      end
      @directory_stat = new_stat
    else
      # Directory has been removed
      @stats.clear
      @directory_stat = nil
      @file_names.clear
      @subdirectory_names.clear
    end
  end
  
end
