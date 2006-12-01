class AddForeignKeyConstraints < ActiveRecord::Migration
  def self.up
    add_foreign_key :file_info, :directory_id, :directories, :id
    add_foreign_key :servers, :directory_id, :directories, :id
  end

  def self.down
    remove_foreign_key :file_info, :file_info_ibfk_1
    remove_foreign_key :servers, :servers_ibfk_1
  end
end
