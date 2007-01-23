# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base

  @@webapp_config = open(File.dirname(__FILE__) + "/../../config/earth-webapp.yml") { |f| YAML.load(f.read) }
  
  def filter_conditions(params)
    @filter_filename = params[:filter_filename]
    if @filter_filename.nil? || @filter_filename == ""
      @filter_filename = "*"
    end
    @filter_user = params[:filter_user]
    
    @users = User.find_all
    
    if @filter_user && @filter_user != ""    
      filter_conditions = ["files.name LIKE ? AND files.uid = ?", @filter_filename.tr('*', '%'),
        User.find_by_name(@filter_user).uid]
    elsif @filter_filename != '*'
      filter_conditions = ["files.name LIKE ?", @filter_filename.tr('*', '%')]
    else
      filter_conditions = nil
    end
  end    

end
