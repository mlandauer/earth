require File.dirname(__FILE__) + '/abstract_unit'
#require File.dirname(__FILE__) + '/fixtures/mixin'
require 'pp'

class CategoryTest < Test::Unit::TestCase
  fixtures :categories

  def assert_nested_set_order(node, left=1)
    parent = node[0]
    node = node[1, node.length]
    parent.reload
    assert_equal(left, parent.lft, "left of node #{parent.name} assumed to be #{left} but is #{parent.lft}")
    child_left = left + 1
    child_right = child_left
    if node
      node.each do |child|
        child_right = assert_nested_set_order(child, child_left) + 1
        child_left = child_right
      end
    end
    right = child_right
    assert_equal(right, parent.rgt, "right of node #{parent.name} assumed to be #{right} but is #{parent.rgt}")
    right
  end

  def test_insert_1
    root      = Category.new("name" => "root")
    child1    = root.children.build("name" => "child1")
    child1a   = child1.children.build("name" => "child1a")
    root.save
    assert_not_nil root.id
    assert_not_nil child1.id
    assert_not_nil child1a.id

    assert_nested_set_order([root, [child1, [child1a]]])

    child1b  = child1.children.build("name" => "child1b")
    child1b.save
    assert_not_nil child1b.id

    assert_nested_set_order([root, [child1, [child1a], [child1b]]])
  end

  def test_insert_2
    root      = Category.new("name" => "root")
    child1    = root.children.build("name" => "child1")
    child1a   = child1.children.build("name" => "child1a")
    root.save

    assert_nested_set_order([root, [child1, [child1a]]])

    child1b  = child1.children.build("name" => "child1b")
    root.save

    assert_nested_set_order([root, [child1, [child1a], [child1b]]])
  end

  def test_insert_3
    root      = Category.new("name" => "root")
    child1    = root.children.build("name" => "child1")
    child1a   = child1.children.build("name" => "child1a")
    root.save

    assert_nested_set_order([root, [child1, [child1a]]])

    child1b  = Category.new("name" => "child1b")
    child1.add_child(child1b)

    assert_nested_set_order([root, [child1, [child1a], [child1b]]])
  end


  def test_insert_3a
    root      = Category.new("name" => "root")
    child1    = root.children.build("name" => "child1")
    child1a   = child1.children.build("name" => "child1a")
    root.save

    assert_nested_set_order([root, [child1, [child1a]]])

    child1b  = Category.new("name" => "child1b")
    child1b.parent = child1
    child1b.save()

    assert_nested_set_order([root, [child1, [child1a], [child1b]]])
  end

  def test_insert_3b
    root      = Category.new("name" => "root")
    child1    = root.children.build("name" => "child1")
    child1a   = child1.children.build("name" => "child1a")
    root.save

    assert_nested_set_order([root, [child1, [child1a]]])

    child1b  = Category.new("name" => "child1b_xx")
    child1b.parent = child1
    root.save()

    assert_nested_set_order([root, [child1, [child1a], [child1b]]])
  end

  def make_tree(node, parent, &block)
    category = yield(parent, node[0])
    #[ category ] + node[1..node.length].reverse.map { |child| make_tree(child, category, &block) }.reverse
    [ category ] + node[1..node.length].map { |child| make_tree(child, category, &block) }
  end
 
  def build_tree(node)
    tree = make_tree(node, nil) do |parent, name| 
      if parent.nil?
        Category.new("name" => name)
      else
        parent.children.build("name" => name)
      end
    end
    tree[0].save
    tree
  end
 
  def create_tree(node)
    make_tree(node, nil) do |parent, name| 
      if parent.nil?
        category = Category.new("name" => name)
        category.save
        category
      else
        parent.children.create("name" => name)
      end
    end
  end

  def test_insert_4
    names = ["root", ["child1", ["child1a"], ["child1b"]]]
    categories = build_tree(names)
    assert_nested_set_order(categories)
  end

  def destroy_in_tree(node, name, parent=nil)
    head = node[0]
    if head.name == name
      head.destroy
      nil
    else
      rest = node[1..node.length].map { |child| delete_from_tree(child, name, head) }.delete_if { |child| child.nil?}
      [ head ] + rest
    end
  end


  def delete_from_tree(node, name, parent=nil)
    head = node[0]
    if head.name == name
      if parent.nil?
        head.destroy
      else
        parent.children.delete(head)
      end
      nil
    else
      rest = node[1..node.length].map { |child| delete_from_tree(child, name, head) }.delete_if { |child| child.nil?}
      [ head ] + rest
    end
  end

  def test_insert_delete_5
    names = ["root", ["child1", ["child1a"], ["child1b"]]]
    categories = create_tree(names)
    assert_nested_set_order(categories)
    categories = destroy_in_tree(categories, "child1a")
    assert_nested_set_order(categories)
  end

  def test_insert_delete_6
    names = ["root", ["child1", ["child1a"], ["child1b"]]]
    categories = create_tree(names)
    assert_nested_set_order(categories)
    categories = delete_from_tree(categories, "child1a")
    assert_nested_set_order(categories)
  end


  def test_delete_7
    names = ["root", ["child1", ["child1a"], ["child1b"]]]
    categories = create_tree(names)
    assert_nested_set_order(categories)
    categories = delete_from_tree(categories, "child1")
    assert_nested_set_order(categories)
  end


  def test_reorder_7
    root      = Category.new("name" => "root")
    child1    = root.children.build("name" => "child1")
    child1a   = child1.children.build("name" => "child1a")
    child1b   = child1.children.build("name" => "child1b")
    child2    = child1a.children.build("name" => "child2")
    root.save()

    assert_nested_set_order([root, [child1, [child1a, [child2]], [child1b]]])

    child2.parent = child1b
    root.save()

    assert_nested_set_order([root, [child1, [child1a], [child1b, [child2]]]])

  end

end
