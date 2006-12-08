require File.dirname(__FILE__) + '/../test_helper'
require 'directories_controller'

# Re-raise errors caught by the controller.
class DirectoriesController; def rescue_action(e) raise e end; end

class DirectoriesControllerTest < Test::Unit::TestCase
  fixtures :directories, :servers, :file_info

  def setup
    @controller = DirectoriesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_size_with_id
    get :size, :id => directories(:foo).id
    
    assert_response :success
    assert_template 'size'

    assert_equal(directories(:foo), assigns(:directory))
    assert_equal(directories(:foo).size, assigns(:directory_size))
    assert_equal([[directories(:foo_bar), directories(:foo_bar).recursive_size]],
      assigns(:children_and_sizes))
    # Hardcoded value below
    assert_equal(7, assigns(:max_size))
  end
  
  def test_size_with_server_and_path
    get :size, :server => Server.this_hostname, :path => "/foo/bar/twiddle"
    
    assert_response :success
    assert_template 'size'
    
    assert_equal(directories(:foo_bar_twiddle), assigns(:directory))
  end
end
