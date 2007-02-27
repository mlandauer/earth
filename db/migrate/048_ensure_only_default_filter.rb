# The previous migrations involving Filter didn't ensure that there would be a default filter of "*"
class EnsureOnlyDefaultFilter < ActiveRecord::Migration
  def self.up
    execute "DELETE FROM filters WHERE filename != '*' OR uid IS NOT NULL"
    # Delete cached sizes that aren't related to the default size
    execute "DELETE FROM cached_sizes WHERE filter_id != (SELECT id FROM filters WHERE filename = '*' AND uid IS NULL)"
  end

  def self.down
  end
end
