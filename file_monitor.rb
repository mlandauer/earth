# Copyright (C) 2006 Rising Sun Pictures and Matthew Landauer.
# All Rights Reserved.
#  
# This program is free software; you can redistribute it and/or modify it
# under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#
# $Id$

require 'thread'
require 'snapshot'

class FileMonitor
  attr_reader :queue
  
  def initialize(directory)
    @directory = directory
    @snapshot = Snapshot.new(directory)
  end
  
  def exist?(path)
    @snapshot.exist?(path)
  end
  
  def file_added(path, name, stat)
    puts "File #{name} at #{path} added"
  end
  
  def file_removed(path, name)
    puts "File #{name} at #{path} removed"
  end
  
  def update
    old_snapshot = @snapshot
    @snapshot = Snapshot.new(@directory)
    @snapshot.update
    Snapshot.added_files(old_snapshot, @snapshot).each {|x| file_added(File.dirname(x), File.basename(x), @snapshot.stat(x))}
    Snapshot.removed_files(old_snapshot, @snapshot).each {|x| file_removed(File.dirname(x), File.basename(x))}
  end
end

FileAdded = Struct.new(:path, :name, :stat)
FileRemoved = Struct.new(:path, :name)

class MonitorWithQueue < FileMonitor
  def initialize(directory)
    super(directory)
    @queue = Queue.new    
  end
  
  def file_added(path, name, stat)
    @queue.push(FileAdded.new(path, name, stat))
  end
  
  def file_removed(path, name)
    @queue.push(FileRemoved.new(path, name))
  end
end

