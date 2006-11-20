class DirectoryTree 
  attr_reader :path, :value, :children

  def initialize(path, value, children = [])
    @path = path
    @value = value 
    @children = children 
  end 

  def clone
    DirectoryTree.new(@path, @value, @children.map {|x| x.clone})
  end

  def add(path, value)
    subtree = find(File.dirname(path))
    raise "Couldn't add path #{path}" if subtree.nil?
    subtree.add_to_root(File.basename(path), value)
  end
  
  def delete(path)
    subtree_parent = find(File.dirname(path))
    subtree = find(path)
    if subtree_parent.nil? or subtree.nil?
      raise "Can not delete" 
    end
    if !subtree.children.empty?
      raise "Can not delete directory with subdirectories"
    end
    subtree_parent.children.delete(subtree)
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
  
  # Naive implementation of find (searches through
  # every node)
  def find(path)
    if @path == path
      return self
    else
      @children.each do |child|
        s = child.find(path)
        if s
          return s
        end
      end
    end
    return nil
  end
end 
