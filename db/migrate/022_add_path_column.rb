# Added path column back in so that we can quickly find directories by path
class AddPathColumn < ActiveRecord::Migration
  def self.up
    add_column :directories, :path, :string, :null => false
  end

  def self.down
    remove_column :directories, :path
  end
end
