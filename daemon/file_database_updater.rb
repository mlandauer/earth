require 'socket'

class FileDatabaseUpdater
  def file_added(directory, name, stat)
    #puts "File ADDED: #{name} in directory #{directory.path}"
    FileInfo.create(:directory => directory, :name => name, :stat => stat)
  end
  
  def file_removed(file)
    #puts "File REMOVED: #{file.name} in directory #{file.directory.path}"
    file.destroy
  end
  
  def file_changed(file, stat)
    #puts "File CHANGED: #{file.name} in directory #{file.path}"
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
      Directory.create(:path => name)
    else
      new_directory = Directory.create(:path => File.join(directory.path, name))
      new_directory.move_to_child_of directory
      new_directory
    end
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
