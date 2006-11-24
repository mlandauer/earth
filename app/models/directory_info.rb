class File
  class Stat
    alias old_equals ==
    
    def ==(stat)
      if stat.class == self.class
        return old_equals(stat)
      else
        return stat == self
      end
    end
  end
end

class DirectoryInfo < ActiveRecord::Base
  acts_as_tree
  has_many :file_info

  Stat = Struct.new(:mtime)
  class Stat
    def ==(stat)
      mtime == stat.mtime
    end
  end

  # Convenience method for setting all the fields associated with stat in one hit
  def stat=(stat)
    self.modified = stat.mtime unless stat.nil?
  end
  
  # Returns a "fake" Stat object with some of the same information as File::Stat
  def stat
    Stat.new(modified) unless modified.nil?
  end
  
  # Only returns the last part of the path
  def name
    File.basename(path)
  end
  
  def server
    Server.find_by_directory_info_id(root.id)
  end
end
