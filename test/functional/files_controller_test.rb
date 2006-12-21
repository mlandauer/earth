require File.dirname(__FILE__) + '/../test_helper'
require 'files_controller'

# Re-raise errors caught by the controller.
class FilesController; def rescue_action(e) raise e end; end

class FilesControllerTest < Test::Unit::TestCase
  fixtures :servers, :directories, :files
  set_fixture_class :servers => Earth::Server, :directories => Earth::Directory, :files => Earth::File

  def setup
    @controller = FilesController.new
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
    post :find, :filename => "a", :user => "1", :size => "1"
    assert_response :success
    assert_template 'results'
    assert_equal("a", assigns('filename_value'))
    assert_equal("1", assigns('user_value'))
    assert_equal("1", assigns('size_value'))
    assert_equal([files(:file1), files(:file3)], assigns(:files))
  end
end
