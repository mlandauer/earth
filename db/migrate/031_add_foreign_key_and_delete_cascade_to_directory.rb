# Add constraint to file and directory nodes so that a delete on a directory deletes all dependent rows
class AddForeignKeyAndDeleteCascadeToDirectory < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE directories ADD CONSTRAINT directories_parent_id_fk FOREIGN KEY (parent_id) REFERENCES directories(id) ON DELETE CASCADE" 
 end

  def self.down
    execute "ALTER TABLE directories DROP CONSTRAINT directories_parent_id_fk FOREIGN KEY (parent_id) REFERENCES directories(id) ON DELETE CASCADE" 
  end
end
