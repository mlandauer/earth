# Do nothing. Accidently skipped a migration so going back and adding an empty one to fill the gap
class EmptyMigration < ActiveRecord::Migration
  def self.up
  end

  def self.down
  end
end
