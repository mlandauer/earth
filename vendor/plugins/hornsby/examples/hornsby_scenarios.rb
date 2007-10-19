scenario :apple do
  @apple = Fruit.create! :species => 'apple'
end

scenario :orange do
  @orange = Fruit.create! :species => 'orange'
end

scenario :fruitbowl => [:apple,:orange] do
  @fruitbowl = FruitBowl.create! :fruit => [@apple,@orange]
end

scenario :kitchen => :fruitbowl do
  @kitchen = Kitchen.create! :fruitbowl => @fruitbowl
end

1.upto(9) do |i|
  scenario("user_#{i}") do
    user = User.create! :name => "user#{i}"
    instance_variable_set("@user_#{i}",user)
  end
end