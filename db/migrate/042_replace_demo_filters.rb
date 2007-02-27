class ReplaceDemoFilters < ActiveRecord::Migration
  def self.up
    execute "DELETE FROM filters WHERE id IN (2, 3, 4)"
    execute "INSERT INTO filters(filename, uid) VALUES ('*.tiff', NULL)"
  end

  def self.down
    execute "DELETE FROM filters WHERE id=5"
    execute "INSERT INTO filters(filename, uid) VALUES ('*.zip', NULL)"
    execute "INSERT INTO filters(filename, uid) VALUES ('*.jar', NULL)"
    execute "INSERT INTO filters(filename, uid) VALUES ('*.gif', NULL)"
  end
end
