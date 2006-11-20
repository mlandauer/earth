class DirectoryTree 
  attr_reader :value

  def initialize(value) 
    @value = value 
    @children = [] 
  end 

  def <<(value) 
    subtree = DirectoryTree.new(value) 
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
    @t = DirectoryTree.new("Parent") 
    child1 = @t << "Child 1" 
    child1 << "Grandchild 1.1" 
    child1 << "Grandchild 1.2" 
    child2 = @t << "Child 2" 
    child2 << "Grandchild 2.1" 
  end
  
  def test_each
    a = []
    @t.each {|x| a << x}
    assert_equal(["Grandchild 1.1", "Grandchild 1.2", "Child 1", "Grandchild 2.1", "Child 2", "Parent"], a)
  end
end