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
  has_many :file_info, :dependent => :delete_all
  belongs_to :server

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
    reload
    children_count > 0
  end
  
  # Finds the root of this directory. This is different from root
  # which is a class method that finds an arbitrary root when there
  # are multiple roots. Is this is a more sensible implementation for
  # "better nested set"?
  def root_of_this
    reload
    self_and_ancestors[0]
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
  
  # Return all the root directories for the given server as an array
  # TODO: Currently not tested
  def Directory.roots_for_server(server)
    Directory.roots.find_all{|d| d.server_id == server.id}
  end
  
  def parent=(parent)
    self.parent_id = parent.id unless parent.nil?
  end
  
  def parent_id=(id)
    write_attribute(:parent_id, id)
    @parent_id_updated = true
  end
  
  def after_save
    if @parent_id_updated
      move_to_child_of(parent)
      @parent_id_updated = false
    end
  end
  
  # Set the path attribute based on name and parent_id
  def before_save
    if parent_id
      write_attribute(:path, File.join(parent.path, name))
    else
      write_attribute(:path, name)
    end
  end
  
  def path=(path)
    raise "Can't set path directly. Set name instead."
  end
  
private

  def path_uncached
    # TODO: Hmmm. Not happy with the reload here. Need to think more...
    reload
    self_and_ancestors.map{|x| x.name}.join('/')
  end
  
end
