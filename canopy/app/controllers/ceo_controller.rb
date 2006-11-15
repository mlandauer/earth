class CeoController < ApplicationController
  layout 'ceo_master'
  
  def if_you_were
    # Presents the Form
  end
  
  def if_you_were_request
    # Processes the Travel Request Form
    email = Notifications.deliver_if_you_were(@params['ceo'])
    redirect_to :action => "thanks"
  end

end
