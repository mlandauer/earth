require File.dirname(__FILE__) + '/../test_helper'

class DirectoryTreeTest < Test::Unit::TestCase
  def setup
    @t = DirectoryTree.new("/usr/images", "Parent")
    @t.add("/usr/images", "c1", "Child 1")
    @t.add("/usr/images/c1", "g1.1", "Grandchild 1.1")
    @t.add("/usr/images/c1", "g1.2", "Grandchild 1.2")
    @t.add("/usr/images", "c2", "Child 2")
    @t.add("/usr/images/c2", "g2.1", "Grandchild 2.1")
  end
  
  def test_clone
    t2 = @t.clone
    @t.delete("/usr/images/c1/g1.1")
    @t.add("/usr/images", "c3", "Child 3")
    t_contents = []
    t2_contents = []
    @t.each {|x| t_contents << x}
    t2.each {|x| t2_contents << x}
    assert_equal(["Grandchild 1.2", "Child 1", "Grandchild 2.1", "Child 2", "Child 3", "Parent"], t_contents)
    assert_equal(["Grandchild 1.1", "Grandchild 1.2", "Child 1", "Grandchild 2.1", "Child 2", "Parent"], t2_contents)
  end
  
  def test_add_non_existent
    assert_raise(RuntimeError) {@t.add("/usr/images/foo", "foo2", "foo")}
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
