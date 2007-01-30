class AddCountToCachedSizes < ActiveRecord::Migration
  def self.up
    add_column :cached_sizes, :count, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :cached_sizes, :count
  end
end
