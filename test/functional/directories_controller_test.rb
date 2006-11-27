require File.dirname(__FILE__) + '/../test_helper'
require 'directories_controller'

# Re-raise errors caught by the controller.
class DirectoriesController; def rescue_action(e) raise e end; end

class DirectoriesControllerTest < Test::Unit::TestCase
  def setup
    @controller = DirectoriesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
