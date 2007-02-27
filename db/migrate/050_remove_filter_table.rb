class RemoveFilterTable < ActiveRecord::Migration
  def self.up
    remove_column :cached_sizes, :filter_id
    drop_table :filters
  end

  def self.down
    create_table :filters, :force => true do |t|
      t.column :filename, :string,  :null => false
      t.column :uid,      :integer
    end
    add_column :cached_sizes, :filter_id, :integer, :null => false
  end
end
