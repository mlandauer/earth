class AddFilenameColumn < ActiveRecord::Migration
  def self.up
    add_column :file_info, :name, :string
  end
  
  def self.down
    remove_column :file_info, :name
  end
end
