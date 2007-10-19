describe Fruit, "@apple" do
  before do
    hornsby_scenario :apple
  end
  
  it "should be an apple" do
    @apple.species.should == 'apple'
  end
end

describe FruitBowl, "with and apple and an orange" do
  before do
    hornsby_scenario :fruitbowl
  end
  
  it "should have 2 fruits" do
    @fruitbowl.should have(2).fruit
  end
end