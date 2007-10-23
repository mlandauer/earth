# Copyright (C) 2007 Rising Sun Pictures and Matthew Landauer
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

require File.dirname(__FILE__) + '/../test_helper'

class Earth::FileTest < Test::Unit::TestCase
  fixtures :servers, :directories, :files
  set_fixture_class :servers => Earth::Server, :directories => Earth::Directory, :files => Earth::File

  def test_stat
    # Getting a File::Stat from a "random" file
    stat = File.lstat(File.dirname(__FILE__) + '/../test_helper.rb')
    files(:file1).stat = stat
    # Make sure old equality operator still works for fake stat object
    assert_equal(files(:file1).stat, files(:file1).stat)
    # Testing equality in the long winded way
    assert_equal(stat.mtime, files(:file1).modified)
    assert_equal(stat.size, files(:file1).bytes)
    assert_equal(stat.uid, files(:file1).uid)
    assert_equal(stat.gid, files(:file1).gid)
    # And we should be able to read back as a stat object
    s = files(:file1).stat
    assert_equal(stat.mtime, s.mtime)
    assert_equal(stat.size, s.size)
    assert_equal(stat.uid, s.uid)
    assert_equal(stat.gid, s.gid)
    # And we should be able to directly compare the stats even though they are different kinds of object
    assert_kind_of(File::Stat, stat)
    assert_kind_of(Earth::File::Stat, s)
    assert_equal(stat, s)
    assert_equal(s, stat)
  end
  
  def test_insert_utf8_encoded_filename
    # Inserting some random bit of japanese (encoded in UTF8)
    directories(:foo).files.create(:name => "ストリーミング")
  end
  
  def test_insert_bad_utf8_encoded_filename
    # The character 0xA9 should never appear in UTF8
    assert_raise(ActiveRecord::StatementInvalid) {directories(:foo).files.create(:name => "\xA9")}
  end
end


context "Earth::File building filter" do  
  setup do
    @lachie = User.new(100)
  end
  
  def f(params={})
    @conds = Earth::File.build_filter_conditions(params)
  end
  
  specify "should make file conditions" do
    f(:filter_filename => 'afile').should == ["files.name LIKE ?","afile"]
  end

  specify "should make blank file conditions" do
    f().should.be.nil
  end
  
  specify "should make file wildcard conditions" do
    f(:filter_filename => 'af*ile').should == ["files.name LIKE ?","af%ile"]
  end
  
  specify "should make user conditions" do
    User.expects(:find_by_name).with('lachie').returns(@lachie)
    f(:filter_user => 'lachie').should == ["files.name LIKE ? AND files.uid = ?", '%', 100]
  end
  
  specify "should make user and file conditions" do
    User.expects(:find_by_name).with('lachie').returns(@lachie)
    
    f(:filter_user => 'lachie', :filter_filename => 'afi*le').should == ["files.name LIKE ? AND files.uid = ?", 'afi%le', 100]
  end
end