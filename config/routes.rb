hostname_regex = /\w[\w-]*(\.\w[\w-]*)*/

ActionController::Routing::Routes.draw do |map|
  map.resources :servers

  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  map.connect '', :controller => "browser"

  # Allow pretty URL's for server and path
  # By using the requirements option, we can force :server to be filled with names including dots
  # which normally would be a seperator like '/'.

  # setup controller "browser", action "show"
  map.connect '/browser/show', :controller => "browser", :action => "show"
  map.connect '/browser/show/:server', :controller => "browser", :action => "show",
    :requirements => {:server => hostname_regex}
  map.connect '/browser/show/:server*path', :controller => "browser", :action => "show",
    :requirements => {:server => hostname_regex}
  map.connect '/browser/show.:format/:server*path', :controller => "browser", :action => "show",
    :requirements => {:server => hostname_regex}

  # setup controller "browser", action "flat"
  map.connect '/browser/flat', :controller => "browser", :action => "flat"
  map.connect '/browser/flat/:server', :controller => "browser", :action => "flat",
    :requirements => {:server => hostname_regex}
  map.connect '/browser/flat/:server*path', :controller => "browser", :action => "flat",
    :requirements => {:server => hostname_regex}
  map.connect '/browser/flat.:format/:server*path', :controller => "browser", :action => "flat",
    :requirements => {:server => hostname_regex}

  # setup controller "graph", action "show"
  map.connect '/graph/show', :controller => "graph", :action => "show"
  map.connect '/graph/show/:server', :controller => "graph", :action => "show",
    :requirements => {:server => hostname_regex}
  map.connect '/graph/show/:server*path', :controller => "graph", :action => "show",
    :requirements => {:server => hostname_regex}

  # setup controller "graph", action "index"
  map.connect '/graph', :controller => "graph", :action => "index"
  map.connect '/graph/:server', :controller => "graph", :action => "index",
    :requirements => {:server => hostname_regex}
  map.connect '/graph/:server*path', :controller => "graph", :action => "index",
    :requirements => {:server => hostname_regex}

  map.connect '/servers/show/:server', :controller => "servers", :action => "show",
    :requirements => {:server => hostname_regex}
  map.connect '/servers/edit/:server', :controller => "servers", :action => "edit",
    :requirements => {:server => hostname_regex}

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  
  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action.:format/:id'
end
