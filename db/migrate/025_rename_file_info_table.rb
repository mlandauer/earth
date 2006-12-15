class RenameFileInfoTable < ActiveRecord::Migration
  def self.up
    rename_table :file_info, :files
  end

  def self.down
    rename_table :files, :file_info
  end
end
