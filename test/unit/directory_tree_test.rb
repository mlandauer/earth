class DirectoryTree 
  attr_reader :path, :value, :children

  def initialize(path, value)
    @path = path
    @value = value 
    @children = [] 
  end 

  def add(path, value)
    subtree = find(File.dirname(path))
    raise "Couldn't find to add" if subtree.nil?
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

class DirectoryTreeTest < Test::Unit::TestCase
  def setup
    @t = DirectoryTree.new("/usr/images", "Parent")
    @t.add("/usr/images/c1", "Child 1")
    @t.add("/usr/images/c1/g1.1", "Grandchild 1.1")
    @t.add("/usr/images/c1/g1.2", "Grandchild 1.2")
    @t.add("/usr/images/c2", "Child 2")
    @t.add("/usr/images/c2/g2.1", "Grandchild 2.1")
  end
  
  def test_add_non_existent
    assert_raise(RuntimeError) {@t.add("/usr/images/foo/foo2", "foo")}
  end
  
  def test_delete
    @t.delete("/usr/images/c1/g1.1")
    assert_raise(RuntimeError) {@t.delete("/usr/images/c2")}
    assert_raise(RuntimeError) {@t.delete("foo")}
    @t.delete("/usr/images/c2/g2.1")
    a = []
    @t.each {|x| a << x}
    assert_equal(["Grandchild 1.2", "Child 1", "Child 2", "Parent"], a)
  end
  
  def test_find
    assert_equal("Parent", @t.find("/usr/images").value)
    assert_equal("Grandchild 1.1", @t.find("/usr/images/c1/g1.1").value)
    assert_equal(nil, @t.find("/usr/images/foo"))
  end
  
  def test_each
    a = []
    @t.each {|x| a << x}
    assert_equal(["Grandchild 1.1", "Grandchild 1.2", "Child 1", "Grandchild 2.1", "Child 2", "Parent"], a)
  end
end