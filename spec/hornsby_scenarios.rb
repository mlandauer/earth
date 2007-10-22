scenario :servers do
  @duck = Earth::Server.new :name => 'duck.local'
  @rincewind = Earth::Server.new :name => 'rincewind.local'
  
  @duck.save(false)
  @rincewind.save(false)
end

scenario :directories => :servers do
  @here_dir = @duck.directories.create! :path => '/tmp/foo', :name => 'foo'
  @hidden_dir = @duck.directories.create! :path => "/tmp/.foo", :name => '.foo' 
end