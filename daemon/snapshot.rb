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

  def initialize(observer, directory)
    super(observer)
    @directory = directory
    @subdirectories = Hash.new

    @stats = Hash.new
    @directory_stat = nil
    @file_names = []
    @subdirectory_names = []
  end
  
  def update_contents
    if File.exist?(@directory.path)
      new_stat = File.lstat(@directory.path)
      if new_stat != @directory_stat
        @directory_stat = new_stat
        # Update contents of directory if readable
        if @directory_stat.readable?
          entries = Dir.entries(@directory.path)
          # Ignore all files and directories starting with '.'
          entries.delete_if {|x| x[0,1] == "."}
          
          # Contains the stat information for both files and directories
          @stats.clear
          entries.each {|x| @stats[x] = File.lstat(File.join(@directory.path, x))}

          @file_names, @subdirectory_names = entries.partition{|x| @stats[x].file?}
        end
      end
    else
      # Directory has been removed
      @stats.clear
      @directory_stat = nil
      @file_names.clear
      @subdirectory_names.clear
    end
  end
  
  def update
    old_file_names = @file_names.clone
    old_subdirectory_names = @subdirectory_names.clone
    old_stats = @stats.clone
    old_directory_stat = @directory_stat
    
    update_contents

    (old_file_names & @file_names).each do |x|
      if old_stats[x] != @stats[x]
        file_changed(@directory, x, @stats[x])
      end
    end
    (@subdirectory_names - old_subdirectory_names).each do |x|
      @subdirectories[x] = directory_added(File.join(directory.path, x))
    end
    (@file_names - old_file_names).each {|x| file_added(@directory, x, @stats[x])}
    (old_file_names - @file_names).each {|x| file_removed(@directory, x)}
    (old_subdirectory_names - @subdirectory_names).each do |x|
      directory_removed(@subdirectories[x])
      @subdirectories.delete(x)
    end
    
    # Send the directory_changed message right at the end
    if @directory_stat != old_directory_stat && File.exist?(@directory.path)
      directory_changed(@directory, @directory_stat)
    end
  end
end
