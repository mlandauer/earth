class ReplaceDemoFilters < ActiveRecord::Migration
  def self.up
    Earth::Filter.delete([2, 3, 4])
    Earth::Filter.create(:filename => '*.tiff', :uid => nil)
  end

  def self.down
    Earth::Filter.delete([5])
    Earth::Filter.create(:filename => '*.zip', :uid => nil)
    Earth::Filter.create(:filename => '*.jar', :uid => nil)
    Earth::Filter.create(:filename => '*.gif', :uid => nil)
  end
end
