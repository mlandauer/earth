require "rubygems" 
require_gem "activerecord" 

ActiveRecord::Base.establish_connection(
  :adapter  => "mysql",
  :host     => "localhost",
  :database => "earth_test",
  :username => "earth",
  :password => "earth"
)

ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.logger.level = Logger::WARN