require File.dirname(__FILE__) + '/../test_helper'
require 'business_forms_controller'

# Re-raise errors caught by the controller.
class BusinessFormsController; def rescue_action(e) raise e end; end

class BusinessFormsControllerTest < Test::Unit::TestCase
  def setup
    @controller = BusinessFormsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
