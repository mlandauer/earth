class AddHeartbeatToServersTable < ActiveRecord::Migration
  def self.up
    add_column :servers, :heartbeat_interval, :integer, :null => false, :default => 5.minutes
    add_column :servers, :heartbeat_time, :timestamp
  end

  def self.down
    remove_column :servers, :heartbeat_interval
    remove_column :servers, :heartbeat_time
  end
end
