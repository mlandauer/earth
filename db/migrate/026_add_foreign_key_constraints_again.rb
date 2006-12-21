class AddForeignKeyConstraintsAgain < ActiveRecord::Migration
  def self.up
    add_foreign_key :files, :directory_id, :directories, :id, { :name => "files_directories_id_fk" }
    add_foreign_key :directories, :server_id, :servers, :id, { :name => "directories_servers_id_fk" }
  end

  def self.down
    remove_foreign_key :files, :files_directories_id_fk
    remove_foreign_key :directories, :directories_servers_id_fk
  end
end
