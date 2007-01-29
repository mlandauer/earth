# Add a new column 'blocks' to table files for recording the
# disk usage (occupied 512-bytes blocks) of a file.
class RenameCachedSizeColumns < ActiveRecord::Migration
  def self.up
    rename_column :cached_sizes, :recursive_size, :size
    rename_column :cached_sizes, :recursive_blocks, :blocks
  end
  def self.down
    rename_column :cached_sizes, :size, :recursive_size
    rename_column :cached_sizes, :blocks, :recursive_blocks
  end
end

