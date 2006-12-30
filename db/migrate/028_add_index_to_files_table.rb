class AddIndexToFilesTable < ActiveRecord::Migration
  def self.up
    add_index :files, :name, :name => "files_name_idx"
  end

  def self.down
    remove_index :files, :name => :files_name_idx
  end
end
