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
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:file_info)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:file_info)
    assert assigns(:file_info).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:file_info)
  end

  def test_create
    num_file_info = FileInfo.count

    post :create, :file_info => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_file_info + 1, FileInfo.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:file_info)
    assert assigns(:file_info).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil FileInfo.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      FileInfo.find(1)
    }
  end
end
