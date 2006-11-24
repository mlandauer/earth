class RemoveServerColumn < ActiveRecord::Migration
  def self.up
    remove_column :directory_info, :server_id
  end

  def self.down
    add_column :directory_info, :server_id, :integer, :null => false
  end
end
