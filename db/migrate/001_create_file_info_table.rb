class CreateFileInfoTable < ActiveRecord::Migration
  def self.up
    create_table :file_info do |t|
      t.column :path, :string
    end
  end
  
  def self.down
    drop_table :file_info
  end  
end
