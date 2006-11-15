class AddStatColumns < ActiveRecord::Migration
  def self.up
    add_column :directory_info, :modified, :datetime
  end

  def self.down
    remove_column :directory_info, :modified
  end
end
