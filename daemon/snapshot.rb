# Copyright (C) 2006 Rising Sun Pictures and Matthew Landauer.
# All Rights Reserved.
#  
# This program is free software; you can redistribute it and/or modify it
# under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#
# $Id$

class Snapshot
  attr_reader :directory, :subdirectories

  def initialize(directory, observer)
    @observer = observer
    @server = directory.server
    @directory = directory
    @stats = Hash.new
    @subdirectories = Hash.new
    @subdirectory_names = []
    @directory.children.each do |x|
      @subdirectories[x.name] = x
      @subdirectory_names << x.name
      @stats[x.name] = x.stat
    end
    @files = Hash.new
    @file_names = []
    @directory.file_info.each do |x|
      @files[x.name] = x
      @file_names << x.name
      @stats[x.name] = x.stat
    end
    @directory_stat = directory.stat
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

    changed_file_names.each do |name|
      @files[name].stat = @stats[name]
      @files[name].save
    end
    added_directory_names.each do |name|
      directory = @server.directories.create(:name => name, :parent => @directory)
      @observer.directory_added(directory) unless @observer.nil?
      @subdirectories[name] = directory
    end
    added_file_names.each do |name|
      @files[name] = FileInfo.create(:directory => @directory, :name => name, :stat => @stats[name])
    end
    removed_file_names.each do |name|
      @files[name].destroy
      @files.delete(name)
    end
    removed_directory_names.each do |name|
      @observer.directory_removed(@subdirectories[name]) unless @observer.nil?
      @subdirectories[name].destroy
      @subdirectories.delete(name)
    end
    
    # Update the directory stat information at the end
    if @directory_stat != old_directory_stat && File.exist?(@directory.path)
      @directory.reload
      @directory.stat = @directory_stat
      @directory.save
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
  
    # Seperately test for whether it's a file or a directory because it could
    # be something like a symbolic link (which we shouldn't follow)
    @file_names = entries.select{|x| @stats[x].file?}
    @subdirectory_names = entries.select{|x| @stats[x].directory?}
  end
  
  def update_contents
    # TODO: remove exist? call as it is an extra filesystem access
    if File.exist?(@directory.path)
      new_stat = File.lstat(@directory.path)
      # Update contents if something has changed and directory is readable
      if new_stat != @directory_stat && new_stat.readable?
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
