# Add a new column 'path' to table directories for redundantly storing
# the full path of the directory.
class AddPathToDirectories < ActiveRecord::Migration
  def self.up
    add_column :directories, :path, :string, :limit => 8192, :null => true

    say_with_time "Updating directories, this might take some time..." do
      Earth::Directory.roots.each do |root|
        root.path = root.name
        setup_children_recursive(root)
      end
    end

    change_column :directories, :path, :string, :limit => 8192, :null => false, :unique => true
    add_index :directories, :path, :unique
  end

  def self.setup_children_recursive(dir)
    dir.save
    dir.children.each do |child|
      child.path = dir.path + "/" + child.name
      setup_children_recursive(child)
    end
  end

  def self.down
    remove_column :directories, :path
  end
end
