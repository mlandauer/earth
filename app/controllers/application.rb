# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base

  @@webapp_config = open(File.dirname(__FILE__) + "/../../config/earth-webapp.yml") { |f| YAML.load(f.read) }
  
end
