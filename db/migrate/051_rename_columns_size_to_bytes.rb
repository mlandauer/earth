class RenameColumnsSizeToBytes < ActiveRecord::Migration
  def self.up
    rename_column :cached_sizes, :size, :bytes
    rename_column :files, :size, :bytes
  end

  def self.down
    rename_column :cached_sizes, :bytes, :size
    rename_column :files, :bytes, :size
  end
end
