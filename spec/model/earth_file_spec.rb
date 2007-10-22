require File.dirname(__FILE__) + '/../spec_helper'

module FileHelper
  def filemocks
    @file        = mock_model(Earth::File, :hidden? => false, :empty? => false)
    @hidden_file = mock_model(Earth::File, :hidden? => true , :empty? => false)    
    @empty_file  = mock_model(Earth::File, :hidden? => false, :empty? => true )

  end
  def setup_files(options)    
    files = options[:files] || [@file,@hidden_file,@empty_file]
    
    @files,@any_empty_files,@any_hidden_files = Earth::File.filter(files, options)
  end
end

describe Earth::File, "filtering" do
  include FileHelper
  
  before do
    filemocks
  end
  
  it "should have 2 file" do
    setup_files(:show_hidden => false)
    
    @files.should == [@file,@empty_file]
    
    @any_hidden_files.should be_true
    @any_empty_files.should be_true
  end
  
  it "should have 3 files" do
    setup_files(:show_hidden => true)    
    
    @files.should == [@file,@hidden_file,@empty_file]
    
    @any_hidden_files.should be_true
    @any_empty_files.should be_true
  end
  
  it "should register empty file" do
    setup_files(:files => [@file,@empty_file])
    
    @any_hidden_files.should be_false
    @any_empty_files.should be_true
  end
  
  it "should register normal file only" do
    setup_files(:files => [@file])
    
    @any_hidden_files.should be_false
    @any_empty_files.should be_false
  end
end


describe Earth::File, "building filter" do
  before do
    @lachie = mock_model(User,:uid => 100)
  end
  
  def f(params={})
    @conds = Earth::File.build_filter_conditions(params)
  end
  
  it "should make file conditions" do
    f(:filter_filename => 'afile').should == ["files.name LIKE ?","afile"]
  end

  it "should make blank file conditions" do
    f().should be_nil
  end
  
  it "should make file wildcard conditions" do
    f(:filter_filename => 'af*ile').should == ["files.name LIKE ?","af%ile"]
  end
  
  it "should make user conditions" do
    User.should_receive(:find_by_name).with('lachie').and_return(@lachie)
    f(:filter_user => 'lachie').should == ["files.name LIKE ? AND files.uid = ?", '%', 100]
  end
  
  it "should make user and file conditions" do
    User.should_receive(:find_by_name).with('lachie').and_return(@lachie)
    f(:filter_user => 'lachie', :filter_filename => 'afi*le').should == ["files.name LIKE ? AND files.uid = ?", 'afi%le', 100]
  end
end