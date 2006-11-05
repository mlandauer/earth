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

class TestPosixFileMonitor < Test::Unit::TestCase
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
    @monitor = PosixFileMonitor.new(@dir)
    #@monitor = FileMonitor.new(@dir)
    @monitor.observer = @queue
  end
  
  def teardown
    # Tidy up
    File.chmod(0777, @dir1) if File.exist?(@dir1)
    FileUtils.rm_rf 'test_data'
  end

  # If the daemon doesn't have permission to list the directory
  # it should ignore it
  def test_permissions_directory
    # Remove all permission from directory
    mode = File.stat(@dir1).mode
    @queue.clear
    File.chmod(0000, @dir1)
    @monitor.update
    assert_equal(FileAdded.new(@dir, 'file1', File.lstat(@file1)), @queue.pop)
    assert(@queue.empty?)
    # Add permissions back
    File.chmod(mode, @dir1)
  end
  
  def test_added
    @queue.clear
    @monitor.update
    assert_equal(FileAdded.new(@dir, 'file1', File.lstat(@file1)), @queue.pop)
    assert_equal(FileAdded.new(@dir1, 'file1', File.lstat(@file2)), @queue.pop)
    assert(@queue.empty?)
  end
  
  def test_removed
    @monitor.update
    sleep 2
    FileUtils.rm_rf 'test_data/dir1'
    FileUtils.rm 'test_data/file1'
    @queue.clear
    @monitor.update
    assert_equal(FileRemoved.new(@dir1, 'file1'), @queue.pop)
    assert_equal(FileRemoved.new(@dir, 'file1'), @queue.pop)
    assert(@queue.empty?)
  end
  
  def test_changed
    # Changes the access and modification time on the file to be one minute in the past
    File.utime(Time.now - 60, Time.now - 60, @file2)
    @monitor.update
    sleep 2
    FileUtils.touch @file2
    # For the previous change to be noticed we need to create a new file as well
    file3 = File.join(@dir1, 'file2')
    FileUtils.touch file3
    @queue.clear
    @monitor.update
    assert_equal(FileAdded.new(@dir1, 'file2', File.lstat(file3)), @queue.pop)
    assert_equal(FileChanged.new(@dir1, 'file1', File.lstat(@file2)), @queue.pop)
    assert(@queue.empty?)
  end

  def test_removed2
    FileUtils.mkdir 'test_data/dir1/dir2'
    FileUtils.touch 'test_data/dir1/dir2/file'
    @monitor.update
    sleep 2
    FileUtils.rm_rf 'test_data/dir1'
    @queue.clear
    @monitor.update
    
    assert_equal(FileRemoved.new(File.expand_path('test_data/dir1/dir2'), 'file'), @queue.pop)
    assert_equal(FileRemoved.new(File.expand_path('test_data/dir1'), 'file1'), @queue.pop)
    assert(@queue.empty?)
  end

  def test_added_in_subdirectory
    @monitor.update
    sleep 2
    file3 = File.join(@dir1, 'file2')
    FileUtils.touch file3
    @queue.clear
    @monitor.update
    assert_equal(FileAdded.new(@dir1, 'file2', File.lstat(file3)), @queue.pop)
    assert(@queue.empty?)
  end
  
end
