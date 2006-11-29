class ConvertDirectoryToNestedSet < ActiveRecord::Migration
  def self.up
    add_column :directories, :lft, :integer
    add_column :directories, :rgt, :integer
  end

  def self.down
    remove_column :directories, :lft
    remove_column :directories, :rgt
  end
end
