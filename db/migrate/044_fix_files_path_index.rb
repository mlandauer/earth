class FixFilesPathIndex < ActiveRecord::Migration
  def self.up
    remove_index :files, :path
    add_index :files, :path
  end

  def self.down
    remove_index :files, :path
    add_index :files, :path, :unique
  end
end
