# Add a new column 'blocks' to table files for recording the
# disk usage (occupied 512-bytes blocks) of a file.
class AddBlocksColumnToFiles < ActiveRecord::Migration
  def self.up
    add_column :files, :blocks, :integer, :limit => 13, :null => false, :default => 0
 end

  def self.down
    remove_column :files, :blocks
  end
end
