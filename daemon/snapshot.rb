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
    
    @subdirectories = Hash.new
    @directory.children.each do |x|
      @subdirectories[x.name] = x
    end
  end
  
  def update
    # TODO: remove exist? call as it is an extra filesystem access
    if File.exist?(@directory.path)
      new_directory_stat = File.lstat(@directory.path)
    else
      new_directory_stat = nil
    end
    
    # If directory hasn't changed then return
    if new_directory_stat == @directory.stat
      return
    end
   
    # Set files from @directory
    # This will only load the files when we know that a directory has changed.
    files = Hash.new
    @directory.file_info.each do |x|
      files[x.name] = x
    end
    
    # Set old_stats, old_file_names and old_subdirectory_names from files and @subdirectories
    old_stats = Hash.new
    @subdirectories.each do |name, x|
      old_stats[name] = x.stat
    end
    @directory.file_info.each do |x|
      old_stats[x.name] = x.stat
    end
    old_file_names = @directory.file_info.map{|f| f.name}
    old_subdirectory_names = @subdirectories.keys
    
    file_names, subdirectory_names, stats = [], [], Hash.new
    if new_directory_stat && new_directory_stat.readable? && new_directory_stat.executable?
      file_names, subdirectory_names, stats = contents(@directory)
    end

    changed_file_names = (old_file_names & file_names).reject {|x| old_stats[x] == stats[x]}
    added_file_names = file_names - old_file_names
    removed_file_names = old_file_names - file_names
    added_directory_names = subdirectory_names - old_subdirectory_names
    removed_directory_names = old_subdirectory_names - subdirectory_names

    changed_file_names.each do |name|
      files[name].stat = stats[name]
      files[name].save
    end
    added_directory_names.each do |name|
      directory = @server.directories.create(:name => name, :parent => @directory)
      @observer.directory_added(directory) unless @observer.nil?
      @subdirectories[name] = directory
    end
    # By adding and removing files on the association, the cache of the association will be kept up to date
    added_file_names.each do |name|
      @directory.file_info.create(:name => name, :stat => stats[name])
    end
    removed_file_names.each do |name|
      @directory.file_info.delete(files[name])
    end
    removed_directory_names.each do |name|
      @observer.directory_removed(@subdirectories[name]) unless @observer.nil?
      @subdirectories[name].destroy
      @subdirectories.delete(name)
    end
    
    # Update the directory stat information at the end
    if File.exist?(@directory.path)
      @directory.reload
      @directory.stat = new_directory_stat
      @directory.save
    end
  end

private

  def contents(directory)
    entries = Dir.entries(directory.path)
    # Ignore all files and directories starting with '.'
    entries.delete_if {|x| x[0,1] == "."}
    
    # Contains the stat information for both files and directories
    stats = Hash.new
    entries.each {|x| stats[x] = File.lstat(File.join(directory.path, x))}
  
    # Seperately test for whether it's a file or a directory because it could
    # be something like a symbolic link (which we shouldn't follow)
    file_names = entries.select{|x| stats[x].file?}
    subdirectory_names = entries.select{|x| stats[x].directory?}
    
    return file_names, subdirectory_names, stats
  end
end
