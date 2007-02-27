class AddDeleteCascadeToDirectories < ActiveRecord::Migration
  def self.up
    remove_foreign_key :directories, :directories_servers_id_fk
    add_foreign_key :directories, :server_id, :servers, :id, { :on_delete => :cascade, :name => "directories_servers_id_fk" }
  end

  def self.down
    remove_foreign_key :directories, :directories_servers_id_fk
    add_foreign_key :directories, :server_id, :servers, :id, { :name => "directories_servers_id_fk" }
  end
end
