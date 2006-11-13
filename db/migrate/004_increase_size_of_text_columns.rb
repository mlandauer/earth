class IncreaseSizeOfTextColumns < ActiveRecord::Migration
  def self.up
    change_column :file_info, :path, :text
    change_column :file_info, :name, :text
  end
  
  def self.down
    change_column :file_info, :path, :string
    change_column :file_info, :name, :string
  end
end
