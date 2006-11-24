require File.dirname(__FILE__) + '/../test_helper'

class DirectoryInfoTest < Test::Unit::TestCase
  fixtures :directory_info, :servers

  def test_server
    assert_equal(servers(:first), directory_info(:foo_bar_twiddle).server)
  end
  
  def test_name
    assert_equal("twiddle", directory_info(:foo_bar_twiddle).name)
  end
  
  def test_stat
    # Getting a File::Stat from a "random" file
    stat = File.lstat(File.dirname(__FILE__) + '/../test_helper.rb')
    directory_info(:foo).stat = stat
    assert_equal(stat.mtime, directory_info(:foo).modified)
    # And we should be able to read back as a stat object
    assert_equal(stat.mtime, directory_info(:foo).stat.mtime)
    # And we should be able to directly compare the stats even though they are different kinds of object
    assert_kind_of(File::Stat, stat)
    assert_kind_of(DirectoryInfo::Stat, directory_info(:foo).stat)
    assert_equal(stat, directory_info(:foo).stat)
    assert_equal(directory_info(:foo).stat, stat)
  end
end
