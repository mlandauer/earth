class DirectoryTree 
  attr_reader :value

  def initialize(path, value)
    @path = path
    @value = value 
    @children = [] 
  end 

  # Add an item to the root of this tree
  def add_to_root(path, value) 
    subtree = DirectoryTree.new(path, value) 
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
end 

class DirectoryTreeTest < Test::Unit::TestCase
  def setup
    @t = DirectoryTree.new("/usr/images", "Parent") 
    child1 = @t.add_to_root("c1", "Child 1")
    child1.add_to_root("g1.1", "Grandchild 1.1")
    child1.add_to_root("g1.2", "Grandchild 1.2")
    child2 = @t.add_to_root("c2", "Child 2")
    child2.add_to_root("g2.1", "Grandchild 2.1")
  end
  
  def test_each
    a = []
    @t.each {|x| a << x}
    assert_equal(["Grandchild 1.1", "Grandchild 1.2", "Child 1", "Grandchild 2.1", "Child 2", "Parent"], a)
  end
end