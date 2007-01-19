# Add a new column 'level' to table directories for recording the
# level of a node in the tree, and create an index for it
class AddLevelColumnToDirectories < ActiveRecord::Migration
  def self.up
    add_column :directories, :level, :integer, :null => false
    add_index :directories, :level
 end

  def self.down
    remove_index :directories, :level
    remove_column :directories, :level
  end
end
