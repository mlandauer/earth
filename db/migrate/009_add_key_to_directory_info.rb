class AddKeyToDirectoryInfo < ActiveRecord::Migration
  def self.up
    add_column :file_info, :directory_info_id, :integer
    remove_column :file_info, :path
    remove_column :file_info, :server
  end
  
  def self.down
    add_column :file_info, :path, :text
    add_column :file_info, :server, :string
    remove_column :file_info, :directory_info_id
  end  
end
