class AddParentColumn < ActiveRecord::Migration
  def self.up
    add_column :directory_info, :parent_id, :integer
  end

  def self.down
    remove_column :directory_info, :parent_id
  end
end
