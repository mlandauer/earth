class AddOwnershipColumns < ActiveRecord::Migration
  def self.up
    add_column :file_info, :owner_user, :string
    add_column :file_info, :owner_group, :string
  end
  
  def self.down
    remove_column :file_info, :owner_user
    remove_column :file_info, :owner_group
  end
end
