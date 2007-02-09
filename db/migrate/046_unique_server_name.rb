#
# There must only be one entry per host in the servers table
#
class UniqueServerName < ActiveRecord::Migration
  def self.up
    add_index :servers, :name, :unique
  end

  def self.down
    remove_index :servers, :name
  end
end
