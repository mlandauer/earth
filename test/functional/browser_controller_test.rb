require File.dirname(__FILE__) + '/../test_helper'
require 'browser_controller'

# Re-raise errors caught by the controller.
class BrowserController; def rescue_action(e) raise e end; end

class BrowserControllerTest < Test::Unit::TestCase
  fixtures :servers, :directories, :files
  set_fixture_class :servers => Earth::Server, :directories => Earth::Directory, :files => Earth::File

  def setup
    @controller = BrowserController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_show
    get :show, :server => Earth::Server.this_hostname, :path => "/foo"
    
    assert_response :success
    assert_template 'show'

    assert_equal(directories(:foo), assigns(:directory))
    assert_equal([[directories(:foo_bar), directories(:foo_bar).size]], assigns(:directories_and_size))
  end
  
  def test_show_with_server_and_path
    @request.env['HTTP_ACCEPT'] = 'application/xml'
    get :show, {:server => Earth::Server.this_hostname, :path => "/foo/bar", :show_empty => 1}
    
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
      :child => {:tag => "size_in_bytes", :content => directories(:foo_bar_twiddle).size.to_s}
  end
  
  def test_index
    get :index
    assert_response :redirect
  end

#  def test_show_with_no_server
#    get :show
#
#    assert_response :success
#    assert_template 'show'
#
#    assert_not_nil assigns(:servers_and_sizes)
#  end
  
  def test_routing
    assert_routing("/browser", :controller => "browser", :action => "show")
    assert_routing("/browser/foo.rsp.com.au", :controller => "browser", :action => "show", :server => "foo.rsp.com.au")
    assert_routing("/browser/foo", :controller => "browser", :action => "show", :server => "foo")
    assert_routing("/browser/foo.rsp.com.au/blah/foo/bar",
      :controller => "browser", :action => "show", :server => "foo.rsp.com.au", :path => ["", "blah", "foo", "bar"])
    assert_routing("/browser/foo/blah/foo/bar",
      :controller => "browser", :action => "show", :server => "foo", :path => ["", "blah", "foo", "bar"])
    assert_routing("/browser.xml/foo.rsp.com.au/blah/foo/bar",
      :controller => "browser", :action => "show", :server => "foo.rsp.com.au", :path => ["", "blah", "foo", "bar"], :format => "xml")
  end
end
