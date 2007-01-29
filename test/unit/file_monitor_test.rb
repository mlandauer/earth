
class FileMonitorTest < Test::Unit::TestCase
  def setup
    # Put some test files in the directory test_data
    @relative_dir = 'test_data'
    @dir = File.expand_path(@relative_dir)
    @file1 = File.join(@dir, 'file1')
    @dir1 = File.join(@dir, 'dir1')
    @file2 = File.join(@dir1, 'file1')

    FileUtils.rm_rf @dir
    FileUtils.mkdir_p @dir1
    FileUtils.touch @file1
    FileUtils.touch @file2
    
    # Changes the access and modification time to be one minute in the past
    @past = Time.now - 60
    File.utime(@past, @past, @dir)
    File.utime(@past, @past, @dir1)
    File.utime(@past, @past, @file1)
    File.utime(@past, @past, @file2)
    
    # Clears the contents of the database
    Earth::File.delete_all
    Earth::Directory.delete_all
    Earth::Server.delete_all

    server = Earth::Server.this_server
    @directory = server.directories.create(:name => @dir, :path => @dir
)

    @match_all_filter = Earth::Filter.create(:filename => '*', :uid => nil)
    
  end
  
  def teardown
    # Tidy up
    File.chmod(0777, @dir1) if File.exist?(@dir1)
    FileUtils.rm_rf 'test_data'
  end
  
  # Compare directory object with a directory on the filesystem
  def assert_directory(path, directory)
    assert_equal(path, directory.path)
    assert_equal(File.lstat(path), directory.stat)  
  end
  
  # Compare file object with a file on the filesystem
  def assert_file(path, file)
    assert_equal(File.dirname(path), file.directory.path)
    assert_equal(File.basename(path), file.name)
    assert_equal(File.lstat(path), file.stat)
  end

  def assert_directories(paths, directories)
    assert_equal(paths.size, directories.size)
    paths.each_index{|i| assert_directory(paths[i], directories[i])}
  end
  
  def assert_files(paths, files)
    assert_equal(paths.size, files.size)
    paths.each_index{|i| assert_file(paths[i], files[i])}
  end

  def assert_cached_sizes_match(directory)
    assert_equal(@directory.find_cached_size_by_filter(@match_all_filter).size, @directory.size)
    assert_equal(@directory.find_cached_size_by_filter(@match_all_filter).blocks, @directory.blocks)

    # Note: the following assertion assumes that no sparse or
    # compressed files have been created, as in that case disk usage
    # might be less than actual file size.
    #
    # Create files using /dev/random or something similar so that files are unlikely
    # to be compressed.
    # If testing on a filesystem with compression support and with unlucky random data
    # this might fail!!
    #assert(@directory.size <= @directory.blocks * 512)
  end
  
  # Check that files starting with "." are not ignored
  def test_dot_files
    FileUtils.touch 'test_data/.an_invisible_file'
    FileMonitor.update(@directory)
    assert_cached_sizes_match(@directory)
    assert_equal(".an_invisible_file", Earth::File.find_by_name('.an_invisible_file').name)
  end
  
  def test_added
    FileMonitor.update(@directory)
    assert_directories([@dir, @dir1], Earth::Directory.find(:all, :order => :id))
    assert_files([@file2, @file1], Earth::File.find(:all, :order => :id))
  end

  def test_removed
    FileMonitor.update(@directory)
    FileUtils.rm_rf 'test_data/dir1'
    FileUtils.rm 'test_data/file1'
    FileMonitor.update(@directory)
    assert_cached_sizes_match(@directory)
    
    assert_directories([@dir], Earth::Directory.find(:all, :order => :id))
    assert_files([], Earth::File.find(:all, :order => :id))
  end

  def test_removed2
    dir2 = File.join(@dir1, 'dir2')
    
    FileUtils.mkdir dir2
    FileUtils.touch File.join(dir2, 'file')
    FileMonitor.update(@directory)
    FileUtils.rm_rf @dir1
    FileMonitor.update(@directory)
    assert_cached_sizes_match(@directory)
    
    assert_directories([@dir], Earth::Directory.find(:all, :order => :id))
    assert_files([@file1], Earth::File.find(:all, :order => :id))
  end
  
  def test_changed
    FileMonitor.update(@directory)
    FileUtils.touch @file2
    # For the previous change to be noticed we need to create a new file as well
    # This is only strictly true for the PosixFileMonitor
    file3 = File.join(@dir1, 'file2')
    FileUtils.touch file3
    FileMonitor.update(@directory)
    assert_cached_sizes_match(@directory)
    
    assert_directories([@dir, @dir1], Earth::Directory.find(:all, :order => :id))
    assert_files([@file2, @file1, file3], Earth::File.find(:all, :order => :id))
  end
  
  def test_added_in_subdirectory
    FileMonitor.update(@directory)
    file3 = File.join(@dir1, 'file2')
    FileUtils.touch file3
    FileMonitor.update(@directory)
    assert_cached_sizes_match(@directory)
    
    assert_directories([@dir, @dir1], Earth::Directory.find(:all, :order => :id))
    assert_files([@file2, @file1, file3], Earth::File.find(:all, :order => :id))
  end

  # If the daemon doesn't have permission to list the directory
  # it should ignore it
  def test_permissions_directory
    # Remove all permission from directory
    mode = File.stat(@dir1).mode
    File.chmod(0000, @dir1)
    FileMonitor.update(@directory)
    assert_cached_sizes_match(@directory)
    
    assert_directories([@dir, @dir1], Earth::Directory.find(:all, :order => :id))
    assert_files([@file1], Earth::File.find(:all, :order => :id))

    # Add permissions back
    File.chmod(mode, @dir1)
  end
  
  def test_directory_executable_permissions
    # Make a directory readable but not executable
    mode = File.stat(@dir1).mode
    File.chmod(0444, @dir1)
    FileMonitor.update(@directory)
    assert_cached_sizes_match(@directory)
    
    assert_directories([@dir, @dir1], Earth::Directory.find(:all, :order => :id))
    assert_files([@file1], Earth::File.find(:all, :order => :id))

    # Add permissions back
    File.chmod(mode, @dir1)
  end
  
  def test_removed_watched_directory
    FileMonitor.update(@directory)
    FileUtils.rm_rf @dir
    FileMonitor.update(@directory)
    assert_cached_sizes_match(@directory)
    
    directories = Earth::Directory.find(:all, :order => :id)
    assert_equal(1, directories.size)
    assert_equal(@dir, directories[0].path)
    # Not checking the stat of the top directory as it has been deleted
    
    files = Earth::File.find(:all, :order => :id)
    assert_equal(0, files.size)
  end
  
  def test_directory_added
    FileMonitor.update(@directory)
    assert_cached_sizes_match(@directory)

    subdir = File.join(@dir, "subdir")
    FileUtils.mkdir subdir
    FileMonitor.update(@directory)
    assert_directory(subdir, Earth::Directory.find_by_name("subdir"))
    assert(@directory == Earth::Directory.find_by_name("subdir").parent)
  end

  def create_random_file(file, size)
    assert_equal "", `dd 2>/dev/null >/dev/null if=/dev/random of=#{file} bs=1 count=#{size}`
  end

  def test_directory_cached_sizes_match
    # This performs various changes on a subdirectory and makes sure that
    # cached sizes are updated properly
    FileMonitor.update(@directory)
    assert_cached_sizes_match(@directory)
    assert(@directory.find_cached_size_by_filter(@match_all_filter).size == 0)

    # Create a subdirectory and check that it's been created
    subdir = File.join(@dir, "subdir")
    FileUtils.mkdir subdir
    File.utime(@past, @past, subdir)

    FileMonitor.update(@directory)
    assert_directory(subdir, Earth::Directory.find_by_name("subdir"))
    assert_equal(@directory, Earth::Directory.find_by_name("subdir").parent)
    assert_equal(Earth::Directory.find_by_name(@dir), Earth::Directory.find_by_name("subdir").parent)
    assert_equal(Earth::Directory.find_by_name(@dir).server, Earth::Directory.find_by_name("subdir").server)
    assert_cached_sizes_match(@directory)
    assert(@directory.find_cached_size_by_filter(@match_all_filter).size == 0)

    # Create a single file in the subdirectory and check that sizes still match
    prev_cached_size = @directory.find_cached_size_by_filter(@match_all_filter).size
    file1_size = 3254
    file1 = File.join(subdir, "sub-file1")
    create_random_file(file1, file1_size)
    FileMonitor.update(@directory)
    assert_file(file1, Earth::File.find_by_name('sub-file1'))
    assert_equal(Earth::Directory.find_by_name("subdir"), Earth::File.find_by_name('sub-file1').directory)
    assert_equal(file1_size, Earth::File.find_by_name('sub-file1').size)
    assert_cached_sizes_match(@directory)
    assert_equal(file1_size, Earth::Directory.find_by_name("subdir").size)
    assert_equal(file1_size, Earth::Directory.find_by_name("subdir").find_cached_size_by_filter(@match_all_filter).size)
    assert_equal(file1_size, Earth::Directory.find_by_name(@dir).size)
    assert_equal(file1_size, Earth::Directory.find_by_name(@dir).find_cached_size_by_filter(@match_all_filter).size)
    assert_equal(@directory, Earth::Directory.find_by_name(@dir))
    assert_equal(file1_size, @directory.size)
    assert_equal(file1_size, @directory.find_cached_size_by_filter(@match_all_filter).size)
    assert_equal(@directory.find_cached_size_by_filter(@match_all_filter).size, file1_size)

    sleep 1 # FIXME

    # Create two files in the subdirectory and check that sizes still match
    prev_cached_size = @directory.find_cached_size_by_filter(@match_all_filter).size
    file2 = File.join(subdir, "sub-file2")
    file2_size = 1314
    create_random_file(file2, file2_size)
    file3 = File.join(subdir, "sub-file3")
    file3_size = 2131
    create_random_file(file3, file3_size)
    FileMonitor.update(@directory)
    new_cached_size = @directory.find_cached_size_by_filter(@match_all_filter).size
    assert_equal(file2_size + file3_size, new_cached_size - prev_cached_size)
    assert_cached_sizes_match(@directory)

    # Delete one of the files and check that sizes still match
    #prev_cached_size = @directory.size
    #FileUtils.rm file1
    #FileMonitor.update(@directory)
    #assert_cached_sizes_match(@directory)

  end
end
