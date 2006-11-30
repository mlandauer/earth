class ReplacePathWithNameColumn < ActiveRecord::Migration
  def self.up
    add_column :directories, :name, :string, :null => false
    remove_column :directories, :path
  end

  def self.down
    add_column :directories, :path, :string, :null => false
    remove_column :directories, :name
  end
end
