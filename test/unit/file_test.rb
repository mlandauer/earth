require File.dirname(__FILE__) + '/../test_helper'

class Earth::FileTest < Test::Unit::TestCase
  fixtures :files
  set_fixture_class :files => Earth::File

  def test_stat
    # Getting a File::Stat from a "random" file
    stat = File.lstat(File.dirname(__FILE__) + '/../test_helper.rb')
    files(:file1).stat = stat
    # Testing equality in the long winded way
    assert_equal(stat.mtime, files(:file1).modified)
    assert_equal(stat.size, files(:file1).size)
    assert_equal(stat.uid, files(:file1).uid)
    assert_equal(stat.gid, files(:file1).gid)
    # And we should be able to read back as a stat object
    s = files(:file1).stat
    assert_equal(stat.mtime, s.mtime)
    assert_equal(stat.size, s.size)
    assert_equal(stat.uid, s.uid)
    assert_equal(stat.gid, s.gid)
    # And we should be able to directly compare the stats even though they are different kinds of object
    assert_kind_of(File::Stat, stat)
    assert_kind_of(Earth::File::Stat, s)
    assert_equal(stat, s)
    assert_equal(s, stat)
  end
end
