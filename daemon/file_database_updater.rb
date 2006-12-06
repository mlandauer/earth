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
  
  def directory_added(parent_directory, name)
    if parent_directory.nil?
      directory = Directory.create(:name => name, :path => name)
    else
      directory = Directory.create(:name => name, :path => File.join(parent_directory.path, name))
      directory.move_to_child_of parent_directory
    end
    #puts "Directory ADDED: #{directory.path}"
    directory
  end
  
  def directory_removed(directory)
    #puts "Directory REMOVED: #{directory.path}"
    directory.destroy
  end
  
  def directory_changed(directory, stat)
    #puts "Directory CHANGED: #{directory.path}"
    directory.reload
    directory.stat = stat
    directory.save
  end
end
