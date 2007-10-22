require File.dirname(__FILE__)+'/../spec_helper'

require File.dirname(__FILE__) + '/../spec_helper'

describe Earth::Server, "filtering server list, culling empties" do
  before do
    hornsby_scenario(:servers)
    @size = Size.new(100,200,300)
    
    @duck.stub!(:size).and_return(@size)
    @rincewind.stub!(:size).and_return(Size.new(0,0,0))
    
    @sab,@blank = Earth::Server.filter_and_add_bytes([@duck,@rincewind],:show_empty => false)
  end
    
  it "should return duck" do
    @sab.should have(1).item
    @sab.first.should == [@duck, 100]
  end
end


describe Earth::Server, "filtering server list" do
  before do
    hornsby_scenario(:servers)
    @size = Size.new(100,200,300)
    
    @duck.stub!(:size).and_return(@size)
    @rincewind.stub!(:size).and_return(Size.new(0,0,0))
    
    @sab,@blank = Earth::Server.filter_and_add_bytes([@duck,@rincewind],:show_empty => true)
  end
  
  it "should return two servers" do
    @sab.should have(2).items
  end
  
  it "should have first item as duck" do
    @sab.first.should == [@duck,100]
  end
  
  it "should have second item as rincewind" do
    @sab.last.should == [@rincewind,0]
  end
end