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
    @snapshot = Snapshot.new(directory)
  end
  
  def exist?(path)
    @snapshot.exist?(path)
  end
  
  def file_added(name)
    puts "File #{name} added"
  end
  
  def file_removed(name)
    puts "File #{name} removed"
  end
  
  def update
    old_snapshot = @snapshot.deep_copy
    @snapshot.update
    Snapshot.added_files(old_snapshot, @snapshot).each {|x| file_added(x)}
    Snapshot.removed_files(old_snapshot, @snapshot).each {|x| file_removed(x)}
  end
end

FileAdded = Struct.new(:filename)
FileRemoved = Struct.new(:filename)

class MonitorWithQueue < FileMonitor
  def initialize(directory)
    super(directory)
    @queue = Queue.new    
  end
  
  def file_added(name)
    @queue.push(FileAdded.new(name))
  end
  
  def file_removed(name)
    @queue.push(FileRemoved.new(name))
  end
end

