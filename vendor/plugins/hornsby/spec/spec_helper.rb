require 'fileutils'
require File.dirname(__FILE__) + '/../../../../spec/spec_helper'

plugin_spec_dir = File.dirname(__FILE__)

ActiveRecord::Base.logger = Logger.new(plugin_spec_dir + "/debug.log")

databases = YAML::load(IO.read(plugin_spec_dir + "/db/database.yml"))

db_info = databases[ENV["DB"] || "sqlite3"]

FileUtils::rm(RAILS_ROOT+"/"+db_info[:dbfile])

ActiveRecord::Base.establish_connection(db_info)

load(File.join(plugin_spec_dir, "db", "schema.rb"))
