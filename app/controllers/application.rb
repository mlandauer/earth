# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'erb'

class ApplicationController < ActionController::Base

  @@webapp_config = YAML.load(ERB.new(File.read(File.join(File.dirname(__FILE__), "../../config/earth-webapp.yml"))).result)

  def self.webapp_config
    @@webapp_config
  end
end
