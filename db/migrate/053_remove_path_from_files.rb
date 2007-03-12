# Remove the path column from the files table
class RemovePathFromFiles < ActiveRecord::Migration
  def self.up
    remove_column :files, :path
  end
  def self.down
    add_column :files, :path, :string, :limit => 8192, :null => true
    change_column :files, :path, :string, :limit => 8192, :null => false, :unique => true
    add_index :files, :path, :unique
  end
end
