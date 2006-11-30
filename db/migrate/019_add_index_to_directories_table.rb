class AddIndexToDirectoriesTable < ActiveRecord::Migration
  def self.up
    add_index :directories, :lft
    add_index :directories, :rgt
    add_index :file_info, :directory_id
  end

  def self.down
    remove_index :directories, :lft
    remove_index :directories, :rgt
    remove_index :file_info, :directory_id
  end
end
