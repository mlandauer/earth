require File.dirname(__FILE__) + '/../test_helper'
require 'servers_controller'

# Re-raise errors caught by the controller.
class ServersController; def rescue_action(e) raise e end; end

class ServersControllerTest < Test::Unit::TestCase
  fixtures :servers, :directories, :files

  def setup
    @controller = ServersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:servers_and_sizes)
  end
  
  def test_routing
    assert_routing("/servers/show/foo.rsp.com.au", :controller => "servers", :action => "show", :server => ["foo.rsp.com.au"])
  end
end
