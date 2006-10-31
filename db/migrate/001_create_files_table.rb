class CreateFilesTable < ActiveRecord::Migration
  def self.up
    create_table :files do |t|
      t.column :name,     :string
    end
  end
  
  def self.down
    remove_table :files
  end  
end
