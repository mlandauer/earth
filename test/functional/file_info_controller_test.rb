require File.dirname(__FILE__) + '/../test_helper'
require 'file_info_controller'

# Re-raise errors caught by the controller.
class FileInfoController; def rescue_action(e) raise e end; end

class FileInfoControllerTest < Test::Unit::TestCase
  fixtures :files
  set_fixture_class :files => Earth::File

  def setup
    @controller = FileInfoController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'find'
  end
  
  def test_find
    get :find
    assert_response :success
    assert_template 'find'
  end
  
  def test_results
    post :find, :find_value => "a"
    assert_response :success
    assert_template 'results'
    assert_equal("a", assigns(:find_value))
    assert_equal([files(:file1), files(:file3)], assigns(:file_info))
  end
end
