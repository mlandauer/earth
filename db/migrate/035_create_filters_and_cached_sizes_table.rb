class CreateFiltersAndCachedSizesTable < ActiveRecord::Migration
  def self.up
    create_table :filters do |t|
      t.column :filename, :string, :null => false
      t.column :uid, :integer
    end
    add_index :filters, [:filename, :uid]

    execute "INSERT INTO filters(filename, uid) VALUES ('*', NULL)"
    execute "INSERT INTO filters(filename, uid) VALUES ('*.zip', NULL)"
    execute "INSERT INTO filters(filename, uid) VALUES ('*.jar', NULL)"
    execute "INSERT INTO filters(filename, uid) VALUES ('*.gif', NULL)"
    
    create_table :cached_sizes do |t|
      t.column :directory_id, :integer, :null => false
      t.column :filter_id, :integer, :null => false
      t.column :recursive_size, :integer, :limit => 21, :default => 0, :null => false     # allow for a zettabyte
      t.column :recursive_blocks, :integer, :limit => 19, :default => 0, :null => false   # allow for a zettabyte
      t.foreign_key :directory_id, :directories, :id, { :on_delete => :cascade, :name => "cached_sizes_directories_id_fk"  }
      t.foreign_key :filter_id, :filters, :id, { :on_delete => :cascade, :name => "cached_sizes_filters_id_fk" }
    end
    add_index :cached_sizes, :directory_id
    add_index :cached_sizes, [:directory_id, :filter_id]
  end
  
  def self.down
    drop_table :cached_sizes
    drop_table :filters
  end  
end

