class AddLastUpdateFinishTimeToServer < ActiveRecord::Migration
  def self.up
    add_column :servers, :update_interval, :integer, :null => false, :default => 5.minutes
    add_column :servers, :last_update_finish_time, :timestamp
  end

  def self.down
    remove_column :servers, :update_interval
    remove_column :servers, :last_update_finish_time
  end
end
