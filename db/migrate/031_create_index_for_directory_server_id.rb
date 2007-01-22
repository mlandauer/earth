# Add constraint to file specifying that directory_id is not null
class CreateIndexForDirectoryServerId < ActiveRecord::Migration
  def self.up
    add_index :directories, :server_id, :name => "directories_server_id"
  end

  def self.down
    remove_index :directories, :name => :directories_server_id
  end
end
