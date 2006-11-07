class AddModificationTimeAndSizeColumns < ActiveRecord::Migration
  def self.up
    add_column :file_info, :modified, :timestamp
    # Size of file in bytes (allowing up to about a TB)
    add_column :file_info, :size, :integer, :limit => 15
  end
  
  def self.down
    remove_column :file_info, :modified
    remove_column :file_info, :size
  end
end
