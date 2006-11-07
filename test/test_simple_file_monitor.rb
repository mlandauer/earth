# Copyright (C) 2006 Rising Sun Pictures and Matthew Landauer.
# All Rights Reserved.
#  
# This program is free software; you can redistribute it and/or modify it
# under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#
# $Id$

require "file_monitor"
require "fileutils"

class TestSimpleFileMonitor < Test::Unit::TestCase
  def setup
    # Put some test files in the directory test_data
    @dir = File.expand_path('test_data')
    @file1 = File.join(@dir, 'file1')
    @dir1 = File.join(@dir, 'dir1')
    @file2 = File.join(@dir1, 'file1')

    FileUtils.rm_rf @dir
    FileUtils.mkdir_p @dir1
    FileUtils.touch @file1
    FileUtils.touch @file2
    
    @queue = FileMonitorQueue.new
    @monitor = SimpleFileMonitor.new(@dir)
    @monitor.observer = @queue
  end
  
  def teardown
    # Tidy up
    FileUtils.rm_rf 'test_data'
  end

  def test_added
    @queue.clear
    @monitor.update
    # The directory added message needs to appear before the file added message
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
    FileUtils.mkdir 'test_data/dir1/dir2'
    FileUtils.touch 'test_data/dir1/dir2/file'
    @monitor.update
    FileUtils.rm_rf 'test_data/dir1'
    @queue.clear
    @monitor.update
    
    assert_equal(FileRemoved.new(File.expand_path('test_data/dir1'), 'file1'), @queue.pop)
    assert_equal(FileRemoved.new(File.expand_path('test_data/dir1/dir2'), 'file'), @queue.pop)
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
