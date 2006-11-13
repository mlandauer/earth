# Copyright (C) 2006 Rising Sun Pictures and Matthew Landauer.
# All Rights Reserved.
#  
# This program is free software; you can redistribute it and/or modify it
# under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#
# $Id$

require File.dirname(__FILE__) + '/file_monitor_test'

class SimpleFileMonitorTest < Test::Unit::TestCase
  include FileMonitorTest

  # Factory method
  def file_monitor(dir, queue)
    SimpleFileMonitor.new(dir, queue)
  end
  
  def test_added
    @monitor.update
    # The directory added message needs to appear before the file added message
    assert_equal(DirectoryAdded.new(@dir), @queue.pop)
    assert_equal(DirectoryAdded.new(@dir1), @queue.pop)
    assert_equal(FileAdded.new(@dir, 'file1', File.lstat(@file1)), @queue.pop)
    assert_equal(FileAdded.new(@dir1, 'file1', File.lstat(@file2)), @queue.pop)
    assert(@queue.empty?)
  end
  
  def test_removed
    @monitor.update
    FileUtils.rm_rf 'test_data/dir1'
    FileUtils.rm 'test_data/file1'
    @queue.clear
    @monitor.update
    assert_equal(FileRemoved.new(@dir, 'file1'), @queue.pop)
    assert_equal(FileRemoved.new(@dir1, 'file1'), @queue.pop)
    # Messages for removing directories should appear after the files
    assert_equal(DirectoryRemoved.new(@dir1), @queue.pop)
    assert(@queue.empty?)
  end
  
  def test_changed
    # Changes the access and modification time on the file to be one minute in the past
    File.utime(Time.now - 60, Time.now - 60, @file2)
    @monitor.update
    FileUtils.touch @file2
    @queue.clear
    @monitor.update
    assert_equal(FileChanged.new(@dir1, 'file1', File.lstat(@file2)), @queue.pop)
    assert(@queue.empty?)
  end

  def test_removed2
    dir2 = File.join(@dir1, 'dir2')
    
    FileUtils.mkdir dir2
    FileUtils.touch File.join(dir2, 'file')
    @monitor.update
    FileUtils.rm_rf 'test_data/dir1'
    @queue.clear
    @monitor.update
    
    assert_equal(FileRemoved.new(@dir1, 'file1'), @queue.pop)
    assert_equal(FileRemoved.new(dir2, 'file'), @queue.pop)
    # Messages for removing directories should appear after the files
    assert_equal(DirectoryRemoved.new(@dir1), @queue.pop)
    assert_equal(DirectoryRemoved.new(dir2), @queue.pop)
    assert(@queue.empty?)
  end

  def test_added_in_subdirectory
    @monitor.update
    file3 = File.join(@dir1, 'file2')
    FileUtils.touch file3
    @queue.clear
    @monitor.update
    assert_equal(FileAdded.new(@dir1, 'file2', File.lstat(file3)), @queue.pop)
    assert(@queue.empty?)
  end
end
