class AddForeignKeyConstraints < ActiveRecord::Migration
  def self.up
    add_foreign_key :file_info, :directory_id, :directories, :id, { :name => "file_info_directories_id_fk" }
    add_foreign_key :servers, :directory_id, :directories, :id, { :name => "servers_directories_id_fk" }
  end

  def self.down
    remove_foreign_key :file_info, :file_info_directories_id_fk
    remove_foreign_key :servers, :servers_directories_id_fk
  end
end
