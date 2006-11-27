class RenameDirectoryInfoTable < ActiveRecord::Migration
  def self.up
    rename_table :directory_info, :directories
    rename_column :file_info, :directory_info_id, :directory_id
    rename_column :servers, :directory_info_id, :directory_id
  end

  def self.down
    rename_table :directories, :directory_info
    rename_column :file_info, :directory_id, :directory_info_id
    rename_column :servers, :directory_id, :directory_info_id
  end
end
