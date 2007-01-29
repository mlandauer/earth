require File.dirname(__FILE__) + '/../test_helper'
require 'servers_controller'

# Re-raise errors caught by the controller.
class ServersController; def rescue_action(e) raise e end; end

class ServersControllerTest < Test::Unit::TestCase
  fixtures :servers, :directories, :files
  set_fixture_class :servers => Earth::Server, :directories => Earth::Directory, :files => Earth::File

  def setup
    @controller = ServersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:servers)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_show_server
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_server
    put :update, :id => 1, :server => { }
    assert_redirected_to server_path(assigns(:server))
  end
end
