class CreateFilesTable < ActiveRecord::Migration
  def self.up
    create_table :files do |t|
      t.column :path, :string
    end
  end
  
  def self.down
    drop_table :files
  end  
end
