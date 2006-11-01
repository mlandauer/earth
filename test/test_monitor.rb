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

class TestMonitor < Test::Unit::TestCase
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
    
    @monitor = MonitorWithQueue.new(@dir)
  end
  
  def teardown
    # Tidy up
    FileUtils.rm_rf 'test_data'
  end

  def test_empty    
    assert(!@monitor.exist?(File.join(@dir, 'file1')))
    assert(!@monitor.exist?(File.join(@dir, 'file2')))
  end
  
  def test_update
     # It should only update its knowledge of the files on calling update
    @monitor.update
    assert(@monitor.exist?(File.join(@dir, 'file1')))
    assert(!@monitor.exist?(File.join(@dir, 'file2')))    
  end
  
  # Those pesky '.' and '..' directories shouldn't be there
  def test_hidden_files
    @monitor.update
    assert(!@monitor.exist?(File.join(@dir, '.')))
    assert(!@monitor.exist?(File.join(@dir, '..'))) 
  end
  
  def test_recursive
    @monitor.update
    assert(@monitor.exist?(File.join(@dir, 'dir1/file1')))
    assert(!@monitor.exist?(File.join(@dir, 'dir1/file2')))
  end
  
  def test_added
    @monitor.queue.clear
    @monitor.update
    assert_equal(FileAdded.new(@dir, 'file1', File.mtime(@file1)), @monitor.queue.pop)
    assert_equal(FileAdded.new(@dir1, 'file1', File.mtime(@file2)), @monitor.queue.pop)
    assert(@monitor.queue.empty?)
  end
  
  def test_removed
    @monitor.update
    FileUtils.rm_rf 'test_data/dir1'
    FileUtils.rm 'test_data/file1'
    @monitor.queue.clear
    @monitor.update
    assert_equal(FileRemoved.new(File.expand_path('test_data'), 'file1'), @monitor.queue.pop)
    assert_equal(FileRemoved.new(File.expand_path('test_data/dir1'), 'file1'), @monitor.queue.pop)
    assert(@monitor.queue.empty?)
  end
  
  def test_removed2
    FileUtils.mkdir 'test_data/dir1/dir2'
    FileUtils.touch 'test_data/dir1/dir2/file'
    @monitor.update
    FileUtils.rm_rf 'test_data/dir1'
    @monitor.queue.clear
    @monitor.update
    
    assert_equal(FileRemoved.new(File.expand_path('test_data/dir1'), 'file1'), @monitor.queue.pop)
    assert_equal(FileRemoved.new(File.expand_path('test_data/dir1/dir2'), 'file'), @monitor.queue.pop)
    assert(@monitor.queue.empty?)
  end

  def test_change_in_subdirectory
    @monitor.update
    file3 = File.join(@dir1, 'file2')
    FileUtils.touch file3
    @monitor.queue.clear
    @monitor.update
    assert_equal(FileAdded.new(@dir1, 'file2', File.mtime(file3)), @monitor.queue.pop)
    assert(@monitor.queue.empty?)
  end
  
end
