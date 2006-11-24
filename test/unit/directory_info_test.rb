require File.dirname(__FILE__) + '/../test_helper'

class DirectoryInfoTest < Test::Unit::TestCase
  fixtures :directory_info, :servers

  def test_server
    assert_equal(servers(:first), directory_info(:foo_bar_twiddle).server)
  end
end
