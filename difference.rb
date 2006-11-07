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
  
  def Difference.changed_files_recursive(snap1, snap2)
    changes = changed_files(snap1, snap2)
    common_directories(snap1, snap2).each do |d|
      changes += changed_files_recursive(snap1.snapshots[d], snap2.snapshots[d])
    end
    changes
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
  
  def Difference.added_files_recursive(snap1, snap2)
    changes = added_files(snap1, snap2)
    added_directories(snap1, snap2).each do |directory|
      changes += added_files_recursive(SnapshotRecursive.new, snap2.snapshots[directory])
    end
    common_directories(snap1, snap2).each do |d|
      changes += added_files_recursive(snap1.snapshots[d], snap2.snapshots[d])
    end
    changes
  end
    
  def Difference.removed_files_recursive(snap1, snap2)
    added_files_recursive(snap2, snap1)
  end
  
  def Difference.added_directories_recursive(snap1, snap2)
    changes = added_directories(snap1, snap2)
    added_directories(snap1, snap2).each do |directory|
      changes += added_directories_recursive(SnapshotRecursive.new, snap2.snapshots[directory])
    end
    common_directories(snap1, snap2).each do |d|
      changes += added_directories_recursive(snap1.snapshots[d], snap2.snapshots[d])
    end
    changes
  end
end
