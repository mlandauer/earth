require File.dirname(__FILE__) + '/../test_helper'
require 'graph_controller'

# Re-raise errors caught by the controller.
class GraphController; def rescue_action(e) raise e end; end

class GraphControllerTest < Test::Unit::TestCase
  fixtures :servers, :directories, :files, :cached_sizes
  set_fixture_class :servers => Earth::Server, :directories => Earth::Directory, :files => Earth::File

  def setup
    @controller = GraphController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index_root
    get :index

    assert_response :success
    assert_template 'index'

    #assert_equal(directories(:foo), assigns(:directory))
    #assert_equal([[directories(:foo_bar), directories(:foo_bar).size]], assigns(:directories_and_size))
    
  end

  def test_index_subdirectory_unfiltered
    get :index, :server => Earth::Server.this_hostname, :path => "/foo/bar/twiddle/frob"

    assert_response :success
    assert_template 'index'

    #assert_equal(directories(:foo), assigns(:directory))
    #assert_equal([[directories(:foo_bar), directories(:foo_bar).size]], assigns(:directories_and_size))
    
  end

  def test_show_root
    get :show

    assert_response :success
    assert_template 'servers.rxml'

    #assert_equal(directories(:foo), assigns(:directory))
    #assert_equal([[directories(:foo_bar), directories(:foo_bar).size]], assigns(:directories_and_size))
    
  end

  def test_show_server
    get :show, :server => Earth::Server.this_hostname

    assert_response :success
    assert_template 'directory.rxml'

    #assert_equal(directories(:foo), assigns(:directory))
    #assert_equal([[directories(:foo_bar), directories(:foo_bar).size]], assigns(:directories_and_size))
    
  end


  def test_show_yet_another_server
    get :show, :server => servers(:yet_another).name

    assert_response :success
    assert_template 'directory.rxml'

    #assert_equal(directories(:foo), assigns(:directory))
    #assert_equal([[directories(:foo_bar), directories(:foo_bar).size]], assigns(:directories_and_size))
    
  end

  def test_show_directory_unfiltered
    get :show, :server => Earth::Server.this_hostname, :path => "/foo"

    assert_response :success
    assert_template 'directory.rxml'

    #assert_equal(directories(:foo), assigns(:directory))
    #assert_equal([[directories(:foo_bar), directories(:foo_bar).size]], assigns(:directories_and_size))
    
  end

  def test_show_subdirectory_unfiltered
    get :show, :server => Earth::Server.this_hostname, :path => "/foo/bar/twiddle/frob"

    assert_response :success
    assert_template 'directory.rxml'

    #assert_equal(directories(:foo), assigns(:directory))
    #assert_equal([[directories(:foo_bar), directories(:foo_bar).size]], assigns(:directories_and_size))
    
  end

  def test_show_directory_filter_filename
    get :show, :server => Earth::Server.this_hostname, :path => "/foo", :filter_filename => "*.zip"

    assert_response :success
    assert_template 'directory.rxml'

    #assert_equal(directories(:foo), assigns(:directory))
    #assert_equal([[directories(:foo_bar), directories(:foo_bar).size]], assigns(:directories_and_size))
    
  end

end
