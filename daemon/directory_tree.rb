class DirectoryTree 
  attr_reader :path, :value, :children

  def initialize(path, value, children = [])
    @path = path
    @value = value 
    @children = children
    @all_children = {path => self}
  end 

  def clone
    DirectoryTree.new(@path, @value, @children.map {|x| x.clone})
  end

  def add(parent_path, name, value)
    #parent_path = File.dirname(path)
    #name = File.basename(path)
    
    subtree = find(parent_path)
    raise "Couldn't add path #{path}" if subtree.nil?
    t = subtree.add_to_root(name, value)
    @all_children[t.path] = t
  end
  
  def delete(path)
    subtree_parent = find(File.dirname(path))
    subtree = find(path)
    if subtree_parent.nil?
      raise "Can not delete because couldn't find #{File.dirname(path)}. path = #{path}"
    end
    if subtree.nil?
      raise "Can not delete because couldn't find #{path}. path = #{path}" 
    end
    if !subtree.children.empty?
      raise "Can not delete directory with subdirectories"
    end
    subtree_parent.children.delete(subtree)
    @all_children.delete(path)
  end
  
  # Add an item to the root of this tree
  def add_to_root(path, value) 
    subtree = DirectoryTree.new(@path + "/" + path, value) 
    @children << subtree 
    return subtree 
  end

  # Iterate over each node of the tree. Move from the leaf nodes
  # back to the root
  def each 
    @children.each do |child_node| 
      child_node.each { |e| yield e } 
    end 
    yield value 
  end
  
  # Not the dumbest of implementations of find... I guess.
  def find(path)
    @all_children[path]
  end
end 
