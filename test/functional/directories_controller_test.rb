require File.dirname(__FILE__) + '/../test_helper'
require 'directories_controller'

# Re-raise errors caught by the controller.
class DirectoriesController; def rescue_action(e) raise e end; end

class DirectoriesControllerTest < Test::Unit::TestCase
  fixtures :servers, :directories, :files
  set_fixture_class :servers => Earth::Server, :directories => Earth::Directory, :files => Earth::File

  def setup
    @controller = DirectoriesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_show_with_id
    get :show, :id => 1
    
    assert_response :success
    assert_template 'show'

    assert_equal(directories(:foo), assigns(:directory))
    assert_equal([[directories(:foo_bar), directories(:foo_bar).recursive_size]],
      assigns(:directories_and_sizes))
  end
  
  def test_show_with_server_and_path
    @request.env['HTTP_ACCEPT'] = 'application/xml'
    get :show, {:server => Earth::Server.this_hostname, :path => "/foo/bar"}
    
    assert_response :success
    assert_template 'show.rxml'
    
    assert_equal(directories(:foo_bar), assigns(:directory))
    
    # Just check for one the two files
    assert_tag :tag => "file",
      :attributes => {:name => "a"},
      :parent => {:tag => "directory", :attributes => {:path => "/foo/bar"}},
      :child => {:tag => "size_in_bytes", :content => files(:file3).size.to_s}
    # There should only be one directory (in this case)
    assert_tag :tag => "directory",
      :attributes => {:name => "twiddle"},
      :parent => {:tag => "directory", :attributes => {:path => "/foo/bar"}},
      :child => {:tag => "size_in_bytes", :content => directories(:foo_bar_twiddle).recursive_size.to_s}
  end
end
