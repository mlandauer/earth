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
    @request.env['HTTP_ACCEPT'] = 'application/xml'
    get :size, {:server => Server.this_hostname, :path => "/foo/bar"}
    
    assert_response :success
    assert_template 'size.rxml'
    
    assert_equal(directories(:foo_bar), assigns(:directory))
    
    # Just check for one the two files
    assert_tag :tag => "file",
      :attributes => {:name => "a"},
      :parent => {:tag => "directory", :attributes => {:path => "/foo/bar"}},
      :child => {:tag => "size_in_bytes", :content => file_info(:file3).size.to_s}
    # There should only be one directory (in this case)
    assert_tag :tag => "directory",
      :attributes => {:name => "twiddle"},
      :parent => {:tag => "directory", :attributes => {:path => "/foo/bar"}},
      :child => {:tag => "size_in_bytes", :content => directories(:foo_bar_twiddle).recursive_size.to_s}
  end
end
