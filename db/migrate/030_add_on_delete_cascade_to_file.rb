# Add constraint to file and directory nodes so that a delete on a directory deletes all dependent rows
class AddOnDeleteCascadeToFile < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE files DROP CONSTRAINT files_directories_id_fk"
    execute "ALTER TABLE files ADD CONSTRAINT  files_directories_id_fk FOREIGN KEY (directory_id) REFERENCES directories(id) ON DELETE CASCADE" 
 end

  def self.down
    execute "ALTER TABLE files DROP CONSTRAINT files_directories_id_fk"
    execute "ALTER TABLE files ADD CONSTRAINT  files_directories_id_fk FOREIGN KEY (directory_id) REFERENCES directories(id)"
  end
end
