class MakePathColumnBig < ActiveRecord::Migration
  def self.up
    change_column :directories, :path, :text, :null => false
  end

  def self.down
    change_column :directories, :path, :string, :null => false
  end
end
