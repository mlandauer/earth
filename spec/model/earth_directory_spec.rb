require File.dirname(__FILE__) + '/../spec_helper'

module DirHelper
  def do_before(options)
    @dir    = mock_model(Earth::Directory, :size => Size.new(100,200,300), :hidden? => false)
    @empty  = mock_model(Earth::Directory, :size => Size.new(0,0,0)      , :hidden? => false)
    @hidden = mock_model(Earth::Directory, :size => Size.new(50,150,250) , :hidden? => true )
    
    @directories_and_bytes,@any_empty,@any_hidden = Earth::Directory.filter_and_add_bytes([@dir,@empty,@hidden], options)
  end
end

describe Earth::Directory, "filtering with bytes" do
  include DirHelper
  
  it "should have 1 dir, culling empty and hidden" do
    do_before(:show_empty => false, :show_hidden => false)
    @directories_and_bytes.should == [[@dir,100]]
  end

  it "should have 2 dirs, culling empty" do
    do_before(:show_empty => false, :show_hidden => true)
    @directories_and_bytes.should == [[@dir,100],[@hidden,50]]
  end

  it "should have 2 dirs, culling hidden" do
    do_before(:show_empty => true, :show_hidden => false)
    @directories_and_bytes.should == [[@dir,100],[@empty,0]]
  end
  
  it "should have 3 dirs, culling none" do
    do_before(:show_empty => true, :show_hidden => true)
    @directories_and_bytes.should == [[@dir,100],[@empty,0],[@hidden,50]]
  end
end


describe Earth::Directory do
  before do
    hornsby_scenario :directories
  end
  
  it "should be hidden if name starts with ." do
    @hidden_dir.should be_hidden
  end
  
  it "should be visible" do
    @here_dir.should_not be_hidden
  end
end