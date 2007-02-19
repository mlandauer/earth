# The previous migrations involving Filter didn't ensure that there would be a default filter of "*"
class EnsureOnlyDefaultFilter < ActiveRecord::Migration
  def self.up
    Earth::Filter.delete_all("filename != '*' OR uid IS NOT NULL")
    filter = Earth::Filter.find(:first, :conditions => "filename = '*' AND uid IS NULL")
    if filter.nil?
      filter = Earth::Filter.create(:filename => '*', :uid => nil)
    end
    # Delete cached sizes that aren't related to the default size
    Earth::CachedSize.delete_all("filter_id != #{filter.id}")
  end

  def self.down
  end
end
