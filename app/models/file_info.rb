class FileInfo < ActiveRecord::Base
  belongs_to :directory_info
  
  # Convenience method for setting all the fields associated with stat in one hit
  def stat=(stat)
    self.modified = stat.mtime
    self.size = stat.size
    self.uid = stat.uid
    self.gid = stat.gid
  end
  
  def FileInfo.find_by_directory_info_and_name(directory, name)
    FileInfo.find(:first, :conditions => ['directory_info_id = ? AND name = ?', directory.id, name])
  end
  
  def path
    directory_info.path
  end
end
