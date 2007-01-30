class AddPathToFiles < ActiveRecord::Migration
  def self.up
    add_column :files, :path, :string, :limit => 8192, :null => true

    say_with_time "Adding path to files, this might take some time..." do
      Earth::File.find(:all).each do |file|
        file.path = file.directory.path + "/" + file.name
      end
    end

    change_column :files, :path, :string, :limit => 8192, :null => false, :unique => true
    add_index :files, :path, :unique
  end

  def self.down
    remove_column :files, :path
  end
end
