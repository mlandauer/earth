class AddOnDeleteCascadeToFilesTable < ActiveRecord::Migration
  def self.up
    remove_foreign_key :files, :files_directories_id_fk
    add_foreign_key :files, :directory_id, :directories, :id,
      :on_delete => :cascade, :name => "files_directories_id_fk"
  end

  def self.down
    remove_foreign_key :files, :files_directories_id_fk
    add_foreign_key :files, :directory_id, :directories, :id,
      :name => "files_directories_id_fk"
  end
end
