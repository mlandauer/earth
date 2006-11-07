class CreateDirectoryInfoTable < ActiveRecord::Migration
  def self.up
    create_table :directory_info do |t|
      t.column :server, :string, :null => false
      t.column :path, :string, :null => false
    end
  end
  
  def self.down
    drop_table :directory_info
  end  
end
