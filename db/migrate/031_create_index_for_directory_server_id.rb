# Add constraint to file specifying that directory_id is not null
class CreateIndexForDirectoryServerId < ActiveRecord::Migration
  def self.up
    execute "CREATE INDEX directories_server_id on directories (server_id)"
 end

  def self.down
    execute "DROP INDEX directories_server_id"
  end
end
