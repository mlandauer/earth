class RemovePathColumnAgain < ActiveRecord::Migration
  def self.up
    remove_column :directories, :path
  end

  def self.down
    add_column :directories, :path, :text, :null => false
  end
end
