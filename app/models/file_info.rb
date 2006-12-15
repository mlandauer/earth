class FileInfo < ActiveRecord::Base
  belongs_to :directory, :class_name => "Earth::Directory"
  composed_of :ownership, :class_name => "Ownership", :mapping => [%w(uid uid), %w(gid gid)]
  
  Stat = Struct.new(:mtime, :size, :uid, :gid)
  class Stat
    def ==(s)
      mtime == s.mtime && size == s.size && uid == s.uid && gid == s.gid
    end
  end
  
  # Convenience method for setting all the fields associated with stat in one hit
  def stat=(stat)
    self.modified = stat.mtime
    self.size = stat.size
    self.uid = stat.uid
    self.gid = stat.gid
  end
  
  # Returns a "fake" Stat object with some of the same information as File::Stat
  def stat
    Stat.new(modified, size, uid, gid)
  end
end
