class AddForeignKeyConstraintsAgain < ActiveRecord::Migration
  def self.up
    add_foreign_key :files, :directory_id, :directories, :id
    add_foreign_key :directories, :server_id, :servers, :id
  end

  def self.down
    remove_foreign_key :files, :files_ibfk_1
    remove_foreign_key :directories, :directories_ibfk_1
  end
end
