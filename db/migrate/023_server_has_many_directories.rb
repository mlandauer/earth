class ServerHasManyDirectories < ActiveRecord::Migration
  def self.up
    add_column :directories, :server_id, :integer, :null => false
    remove_column :servers, :directory_id
  end

  def self.down
    remove_column :directories, :server_id
    add_column :servers, :directory_id, :integer  
  end
end
