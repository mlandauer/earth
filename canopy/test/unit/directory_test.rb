require File.dirname(__FILE__) + '/../test_helper'

class DirectoryTest < Test::Unit::TestCase
  fixtures :directories

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Directory, directories(:first)
  end
end
