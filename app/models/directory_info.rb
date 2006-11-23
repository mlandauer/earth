class DirectoryInfo < ActiveRecord::Base
  acts_as_tree
  belongs_to :server
  
  # Convenience method for setting all the fields associated with stat in one hit
  def stat=(stat)
    self.modified = stat.mtime unless stat.nil?
  end
end
