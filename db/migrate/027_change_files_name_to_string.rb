class ChangeFilesNameToString < ActiveRecord::Migration
  def self.up
    change_column :files, :name, :string
  end

  def self.down
    change_column :files, :name, :text
  end
end
