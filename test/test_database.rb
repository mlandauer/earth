require 'file_info'

class TestDatabase < Test::Unit::TestCase
  def test_connection
    directory = DirectoryInfo.new
    directory.path = 'an/arbitrary/path'
    directory.save
    
    file = FileInfo.new
    file.directory_info = directory
    file.name = 'to_a_file'
    file.save
  end
end
