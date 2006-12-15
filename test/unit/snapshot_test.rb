class SnapshotTest < Test::Unit::TestCase
  def setup
    @dir = File.expand_path('test_data')
    @file2 = File.join(@dir, 'file1')
    @dir2 = File.join(@dir, 'dir2')

    FileUtils.rm_rf @dir
    FileUtils.mkdir @dir
    FileUtils.touch @file2
    FileUtils.mkdir @dir2
    
    # Clears the contents of the database
    Server.delete_all
    FileInfo.delete_all
    Directory.delete_all

    server = Server.this_server
    @directory = server.directories.create(:name => @dir)
    @monitor = Snapshot.new
  end

  def teardown
    FileUtils.rm_rf @dir
  end
  
  def test_removed_watched_directory
    Snapshot.update(@directory)
    FileUtils.rm_rf @dir
    Snapshot.update(@directory)
    
    directories = Directory.find(:all)
    assert_equal(1, directories.size)
    assert_equal(@dir, directories[0].path)
    # Not checking the stat of the top directory as it has been deleted
    
    files = FileInfo.find(:all)
    assert_equal(0, files.size)
  end
end
