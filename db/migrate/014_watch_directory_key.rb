class WatchDirectoryKey < ActiveRecord::Migration
  def self.up
    add_column :servers, :directory_info_id, :integer
    remove_column :servers, :watch_directory
  end

  def self.down
    add_column :servers, :watch_directory, :string, :null => false
    remove_column :servers, :directory_info_id
  end
end
