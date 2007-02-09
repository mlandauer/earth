class AddDaemonVersionToServers < ActiveRecord::Migration
  def self.up
    add_column :servers, :daemon_version, :string, :limit => 128, :null => true
  end

  def self.down
    remove_column :servers, :daemon_version
  end
end
