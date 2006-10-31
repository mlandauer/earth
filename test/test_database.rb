require 'files'

class TestDatabase < Test::Unit::TestCase
  def test_connection
    file = Files.new
    file.path = 'an/arbitrary/path/to_a_file'
    file.save
  end
end
