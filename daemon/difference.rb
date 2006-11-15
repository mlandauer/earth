module Difference
  def Difference.added_files(snap1, snap2)
    snap2.file_names - snap1.file_names
  end
    
  def Difference.removed_files(snap1, snap2)
    snap1.file_names - snap2.file_names
  end
  
  # Files that have not been either added or removed
  def Difference.common_files(snap1, snap2)
    snap2.file_names - added_files(snap1, snap2)
  end
  
  def Difference.changed_files(snap1, snap2)
    common_files(snap1, snap2).select {|f| snap1.stat(f) != snap2.stat(f)}
  end
  
  def Difference.added_directories(snap1, snap2)
    snap2.subdirectory_names - snap1.subdirectory_names
  end
  
  def Difference.removed_directories(snap1, snap2)
    snap1.subdirectory_names - snap2.subdirectory_names
  end
  
  # Directories that have not been either added or removed
  def Difference.common_directories(snap1, snap2)
    snap2.subdirectory_names - added_directories(snap1, snap2)
  end
end
