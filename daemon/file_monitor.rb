# Copyright (C) 2006 Rising Sun Pictures and Matthew Landauer.
# All Rights Reserved.
#  
# This program is free software; you can redistribute it and/or modify it
# under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#
# $Id$

require 'thread'

class FileMonitor
  def initialize(observer)
    @observer = observer
  end
  
  def file_added(directory, name, stat)
    @observer.file_added(directory, name, stat)
  end
  
  def file_removed(directory, name)
    @observer.file_removed(directory, name)
  end
  
  def file_changed(directory, name, stat)
    @observer.file_changed(directory, name, stat)
  end
  
  def directory_added(path)
    @observer.directory_added(path)
  end
  
  def directory_removed(directory)
    @observer.directory_removed(directory)
  end
  
  def directory_changed(directory, stat)
    @observer.directory_changed(directory, stat)
  end
end
