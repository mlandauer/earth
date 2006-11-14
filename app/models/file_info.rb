class FileInfo < ActiveRecord::Base
  belongs_to :directory_info
  
  # Convenience method for setting all the fields associated with stat in one hit
  def stat=(stat)
    self.modified = stat.mtime
    self.size = stat.size
    self.uid = stat.uid
    self.gid = stat.gid
  end
end
