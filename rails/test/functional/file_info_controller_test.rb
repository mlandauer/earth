require File.dirname(__FILE__) + '/../test_helper'
require 'file_info_controller'

# Re-raise errors caught by the controller.
class FileInfoController; def rescue_action(e) raise e end; end

class FileInfoControllerTest < Test::Unit::TestCase
  fixtures :file_info

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
end
