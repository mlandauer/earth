ActionController::Routing::Routes.draw do |map|
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
  map.connect '/browser', :controller => "browser", :action => "show"
  map.connect '/browser/:server', :controller => "browser", :action => "show",
    :requirements => {:server => /\w+(\.\w+)*/}
  map.connect '/browser/:server*path', :controller => "browser", :action => "show",
    :requirements => {:server => /\w+(\.\w+)*/}
  map.connect '/browser.:format/:server*path', :controller => "browser", :action => "show",
    :requirements => {:server => /\w+(\.\w+)*/}

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  
  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action.:format/:id'
end
