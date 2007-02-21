# Make the index on cached_sizes(directory_id, filter_id) unique
class UniqueCachedSizesDirectoryFilter < ActiveRecord::Migration
  def self.up
    remove_index :cached_sizes, [:directory_id, :filter_id]
    add_index :cached_sizes, [:directory_id, :filter_id], :unique
  end

  def self.down
    remove_index :cached_sizes, [:directory_id, :filter_id]
    add_index :cached_sizes, [:directory_id, :filter_id]
  end
end
