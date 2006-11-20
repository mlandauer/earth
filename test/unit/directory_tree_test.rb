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

  def each 
    yield value 
    @children.each do |child_node| 
      child_node.each { |e| yield e } 
    end 
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
    assert_equal(["Parent", "Child 1", "Grandchild 1.1", "Grandchild 1.2", "Child 2", "Grandchild 2.1"], a)
  end
end