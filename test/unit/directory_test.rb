require File.dirname(__FILE__) + '/../test_helper'

class DirectoryTest < Test::Unit::TestCase
  fixtures :directories, :file_info, :servers

  def test_server
    assert_equal(servers(:first), directories(:foo_bar_twiddle).server)
  end
  
  def test_name
    assert_equal("twiddle", directories(:foo_bar_twiddle).name)
  end
  
  def test_stat
    # Getting a File::Stat from a "random" file
    stat = File.lstat(File.dirname(__FILE__) + '/../test_helper.rb')
    directories(:foo).stat = stat
    assert_equal(stat.mtime, directories(:foo).modified)
    # And we should be able to read back as a stat object
    assert_equal(stat.mtime, directories(:foo).stat.mtime)
    # And we should be able to directly compare the stats even though they are different kinds of object
    assert_kind_of(File::Stat, stat)
    assert_kind_of(Directory::Stat, directories(:foo).stat)
    assert_equal(stat, directories(:foo).stat)
    assert_equal(directories(:foo).stat, stat)
  end
  
  def test_size
    assert_equal(file_info(:file1).size + file_info(:file2).size, directories(:foo).size)
    assert_equal(file_info(:file3).size + file_info(:file4).size, directories(:foo_bar).size)
    assert_equal(0, directories(:foo_bar_twiddle).size)
  end
  
  def test_recursive_size
    assert_equal(directories(:foo).size + directories(:foo_bar).size, directories(:foo).recursive_size)
    assert_equal(directories(:foo_bar).size, directories(:foo_bar).recursive_size)
  end
  
  def test_self_and_descendants
    assert_equal([directories(:foo), directories(:foo_bar), directories(:foo_bar_twiddle)],
      directories(:foo).self_and_descendants)
    assert_equal([directories(:foo_bar), directories(:foo_bar_twiddle)],
      directories(:foo_bar).self_and_descendants)
    assert_equal([directories(:foo_bar_twiddle)],
      directories(:foo_bar_twiddle).self_and_descendants)
  end
end
