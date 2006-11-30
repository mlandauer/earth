class File
  class Stat
    alias old_equals ==
    
    def ==(stat)
      if stat.class == self.class
        return old_equals(stat)
      else
        return stat == self
      end
    end
  end
end

class Directory < ActiveRecord::Base
  acts_as_nested_set
  has_many :file_info

  Stat = Struct.new(:mtime)
  class Stat
    def ==(stat)
      mtime == stat.mtime
    end
  end

  # Convenience method for setting all the fields associated with stat in one hit
  def stat=(stat)
    self.modified = stat.mtime unless stat.nil?
  end
  
  # Returns a "fake" Stat object with some of the same information as File::Stat
  def stat
    Stat.new(modified) unless modified.nil?
  end
  
  # Because it's expensive to calculate the path we cache the values
  def path
    if @cached_path.nil?
      @cached_path = path_uncached
    end
    return @cached_path
  end
  
  def has_children?
    children_count > 0
  end
  
  # Finds the root of this directory. This is different from root
  # which is a class method that finds an arbitrary root when there
  # are multiple roots. Is this is a more sensible implementation for
  # "better nested set"?
  def root_of_this
    r = ancestors[0]
    r.nil? ? self : r
  end
  
  def server
    Server.find_by_directory_id(root_of_this.id)
  end
  
  # Size of the files contained directly in this directory
  def size
    a = FileInfo.sum(:size, :conditions => ['directory_id = ?', id])
    # For some reason the above will return nil when there aren't any files
    return a ? a : 0
  end
  
  def recursive_size
    Directory.sum(:size, :conditions => "lft >= #{lft} AND rgt <= #{rgt}",
      :joins => "LEFT JOIN file_info ON file_info.directory_id = directories.id").to_i
  end
  
private

  def path_uncached
    # TODO: Hmmm. Not happy with the reload here. Need to think more...
    reload
    self_and_ancestors.map{|x| x.name}.join('/')
  end
  
end
