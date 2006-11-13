# Copyright (C) 2006 Rising Sun Pictures and Matthew Landauer.
# All Rights Reserved.
#  
# This program is free software; you can redistribute it and/or modify it
# under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#
# $Id$

require File.dirname(__FILE__) + '/file_monitor_test'

class PosixFileMonitorTest < Test::Unit::TestCase
  include FileMonitorTest

  # Factory method
  def file_monitor(dir, queue)
    PosixFileMonitor.new(dir, queue)
  end
  
  # If the daemon doesn't have permission to list the directory
  # it should ignore it
  def test_permissions_directory
    # Remove all permission from directory
    mode = File.stat(@dir1).mode
    @queue.clear
    File.chmod(0000, @dir1)
    @monitor.update
    assert_equal(DirectoryAdded.new(@dir1), @queue.pop)
    assert_equal(FileAdded.new(@dir, 'file1', File.lstat(@file1)), @queue.pop)
    assert(@queue.empty?)
    # Add permissions back
    File.chmod(mode, @dir1)
  end
end
