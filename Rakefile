require "rubygems" 
require_gem "activerecord" 

ActiveRecord::Base.establish_connection(
  :adapter  => "mysql",
  :host     => "localhost",
  :database => "earth_test",
  :username => "earth",
  :password => "earth")

ActiveRecord::Base.logger = Logger.new(STDOUT)

namespace :db do
  desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"
  task :migrate do
    ActiveRecord::Migrator.migrate("db/migrate/", ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
  end
end
