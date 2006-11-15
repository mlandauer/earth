class AddKeyToServer < ActiveRecord::Migration
  def self.up
    add_column :directory_info, :server_id, :integer, :null => false
    remove_column :directory_info, :server
  end

  def self.down
    add_column :directory_info, :server, :string, :null => false
    remove_column :directory_info, :server_id
  end
end
