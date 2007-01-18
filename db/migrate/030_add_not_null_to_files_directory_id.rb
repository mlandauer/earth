# Add constraint to file specifying that directory_id is not null
class AddNotNullToFilesDirectoryId < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE files ALTER directory_id SET NOT NULL"
 end

  def self.down
    execute "ALTER TABLE files ALTER directory_id DROP NOT NULL"
  end
end
