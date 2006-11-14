class CreateServers < ActiveRecord::Migration
  def self.up
    create_table :servers do |t|
      t.column :name, :string, :null => false
      t.column :watch_directory, :string, :null => false
    end
    # Give it a default directory to watch for one of development machines
    execute "INSERT INTO servers (name, watch_directory) VALUES ('duck.local', '/Users/matthewl/earth')"
  end

  def self.down
    drop_table :servers
  end
end
