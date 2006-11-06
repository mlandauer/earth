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
          #entries.map!{|x| File.join(directory, x)}
          
          # TODO: Optimisation - do lstat on all directory entries and use that to determine what is a file
          filenames, @subdirectory_names = entries.partition{|f| File.file?(File.join(directory, f))}
          @stats.clear
          filenames.each {|f| @stats[f] = File.lstat(File.join(directory, f))}
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
