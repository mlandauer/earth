class DirectoryInfo < ActiveRecord::Base
  acts_as_tree
  #belongs_to :server
  
  # Convenience method for setting all the fields associated with stat in one hit
  def stat=(stat)
    self.modified = stat.mtime unless stat.nil?
  end
  
  # Only returns the last part of the path
  def name
    File.basename(path)
  end
  
  def server
    Server.find_by_directory_info_id(root.id)
  end
end
