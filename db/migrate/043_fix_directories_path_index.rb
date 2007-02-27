class FixDirectoriesPathIndex < ActiveRecord::Migration
  def self.up
    remove_index :directories, :path
    add_index :directories, [:path, :server_id], :unique
  end

  def self.down
    remove_index :directories, [:path, :server_id]
    add_index :directories, :path, :unique
  end
end
