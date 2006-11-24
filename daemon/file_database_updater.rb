require 'socket'

class FileDatabaseUpdater
  def file_added(directory, name, stat)
    #puts "File ADDED: #{name} in directory #{directory.path}"
    FileInfo.create(:directory_info => directory, :name => name, :stat => stat)
  end
  
  def file_removed(directory, name)
    #puts "File REMOVED: #{name} in directory #{directory.path}"
    FileInfo.find_by_directory_info_and_name(directory, name).destroy
  end
  
  def file_changed(directory, name, stat)
    #puts "File CHANGED: #{name} in directory #{directory.path}"
    file = FileInfo.find_by_directory_info_and_name(directory, name)
    file.stat = stat
    file.save
  end
  
  def directory_added(directory, name)
    #if directory.nil?
    #  puts "Directory ADDED: #{name} at root"
    #else
    #  puts "Directory ADDED: #{name} in directory #{directory.path}"
    #end
    if directory.nil?
      full_path = name
    else
      full_path = File.join(directory.path, name)
    end
    DirectoryInfo.create(:path => full_path, :parent => directory)
  end
  
  def directory_removed(directory)
    #puts "Directory REMOVED: #{directory.path}"
    directory.destroy
  end
  
  def directory_changed(directory, stat)
    #puts "Directory CHANGED: #{directory.path}"
    directory.stat = stat
    directory.save
  end
end
