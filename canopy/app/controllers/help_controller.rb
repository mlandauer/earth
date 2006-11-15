require 'socket'

class HelpController < ApplicationController
  layout 'layouts/business_forms'

  def tech
    # Present the Tech Request Form
  end
  
  def thanks
    # Place holder for the default Thank You page
  end
  
  def thanks_intranet
    # Place holder for the Thank You page for the Intranet questionnaire
  end
  
  def tech_request
    # Processes the Travel Request Form
    @params['tech']['remote_ip'] = request.remote_ip
    begin
      # Returns a four-element array containing the canonical host name, 
      # a subarray of host aliases, the address family, and the address
      # portion of the sockaddr structure.
      resolved_name = Socket.gethostbyname(request.remote_ip)
      # We only need the DNS name
      @params['tech']['resolved_name'] = resolved_name[0]
    rescue
      # There was some error resolving
      @params['tech']['resolved_name'] = nil
    end
    email = Notifications.deliver_tech_request(@params['tech'])
    redirect_to :action => "thanks"
  end
  
  def intranet
    # Present the Intranet Questionnaire
    @ratings = [["Not Important at all", 0], ["Yeah, maybe...", 1], ["Somewhat important", 2], ["Important", 3], ["Very important", 4], ["Fundamental", 5]]
  end
  
  def intranet_request
    # Processes the Questionnaire
    email = Notifications.deliver_intranet(@params['intranet'])
    redirect_to :action => "thanks_intranet"
  end
end
