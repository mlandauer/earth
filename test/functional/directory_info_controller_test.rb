require File.dirname(__FILE__) + '/../test_helper'
require 'directory_info_controller'

# Re-raise errors caught by the controller.
class DirectoryInfoController; def rescue_action(e) raise e end; end

class DirectoryInfoControllerTest < Test::Unit::TestCase
  def setup
    @controller = DirectoryInfoController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
