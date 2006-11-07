class AddServerColumn < ActiveRecord::Migration
  def self.up
    add_column :file_info, :server, :string
  end
  
  def self.down
    remove_column :file_info, :server
  end
end
