# Since lookup of human readable name from uid appears to be
# troublesome we'll side-step the issue by leaving the uid and gid
# as integers in the database

class ChangeOwnershipInteger < ActiveRecord::Migration
  def self.up
    remove_column :file_info, :owner_user
    remove_column :file_info, :owner_group
    add_column :file_info, :uid, :integer
    add_column :file_info, :gid, :integer
  end
  
  def self.down
    add_column :file_info, :owner_user, :string
    add_column :file_info, :owner_group, :string
    remove_column :file_info, :uid
    remove_column :file_info, :gid
  end
end
