class Notifications < ActionMailer::Base
  
  def travel(travel, sent_at = Time.now)
    @subject        = 'TravelRequest - ' + travel['traveller'] + ' From ' + travel['outdeparting'] + ' To ' + travel['outdestination']
    @body["travel"] = travel
    @recipients     = 'business@rsp.com.au'
    @from           = travel['email']
    @sent_on        = sent_at
    @headers        = {}
  end

  def purchase(purchase, sent_at = Time.now)
    @subject          = 'Notifications#purchase'
    @recipients       = 'business@rsp.com.au'
    @from             = purchase['email']
    @sent_on          = sent_at
    @headers          = {}
    part :content_type => "text/plain",
      :body => render_message("purchase_request", :purchase => purchase)
    unless purchase['uploadedquote'].size == 0
      attachment  :content_type => purchase['uploadedquote'].content_type,
        :filename => purchase['uploadedquote'].original_filename, 
        :body => purchase['uploadedquote'].read
    end
  end

  def expense_claim(sent_at = Time.now)
    @subject    = 'Notifications#expense_claim'
    @body       = {}
    @recipients = ''
    @from       = ''
    @sent_on    = sent_at
    @headers    = {}
  end
  
  def freight(freight, sent_at = Time.now)
    @subject          = 'Notifications#freight'
    @body["freight"]  = freight
    @recipients       = 'business@rsp.com.au'
    @from             = freight['email']
    @sent_on          = sent_at
    @headers          = {}
  end

  def recruitment(recruitment, sent_at = Time.now)
    @subject        = 'Notifications#recruitment - ' + recruitment['name']
    @body["recruitment"] = recruitment
    @recipients     = 'hr@rsp.com.au'
    @from           = 'hr@rsp.com.au'
    @sent_on        = sent_at
    @headers        = {}
  end
  
  def induction_memo(recruitment, sent_at = Time.now)
    @subject        = 'Induction Memo - ' + recruitment['name']
    @body["recruitment"] = recruitment
    @recipients     = ['tech@rsp.com.au', 'hr@rsp.com.au', 'business@rsp.com.au']
    @from           = 'hr@rsp.com.au'
    @sent_on        = sent_at
    @headers        = {}
  end
  
  def tech_request(tech, sent_at = Time.now)
    @subject        = tech['description']
    @body           = { :tech => tech }
    @recipients     = 'tech@rsp.com.au'
    @from           = tech['requestor']
    @sent_on        = sent_at
    @headers        = {}
  end

  def intranet(intranet, sent_at = Time.now)
    @subject          = "Intranet Questionnaire Response"
    @body["intranet"] = intranet
    @recipients       = ['bruno.mattarollo@rsp.com.au', 'andrea.snow@rsp.com.au']
    @from             = 'bruno.mattarollo@rsp.com.au'
    @sent_on          = sent_at
    @headers          = {}
  end

  def leave(leave, recipients, sent_at = Time.now)
    @subject          = leave['options'] + " Leave Request: " + leave['requester'] + " - " + leave['fromdate'] + " to " + leave['todate']
    @recipients       = recipients
    @from             = 'tech@rsp.com.au'
    @sent_on          = sent_at
    @headers          = {}
    part :content_type => "text/plain", 
      :body => render_message("leave_request", :leave => leave)
    attachment  :content_type => "text/calendar",
      :filename => "icalendar_leave_form.ics",
      :body => leave['icalendar_event']
  end
  
  def meeting_room(meetingroom, sent_at = Time.now)
    @subject          = "Meeting Room Request - " + meetingroom['office']
    @recipients       = 'reception@rsp.com.au'
    @from             = 'tech@rsp.com.au'
    @sent_on          = sent_at
    @headers          = {}
    part :content_type => "text/plain", 
      :body => render_message("meeting_room_request", :meetingroom => meetingroom)
    attachment  :content_type => "text/calendar",
      :filename => "icalendar_meeting_room.ics",
      :body => meetingroom['icalendar_event']
  end

  def if_you_were(ceo, sent_at = Time.now)
    @subject          = "If you were CEO - web form"
    @body["ceo"] = ceo
    @recipients       = ['didier.elzinga@rsp.com.au']
    @from             = 'bruno.mattarollo@rsp.com.au'
    @sent_on          = sent_at
    @headers          = {}
  end
  
end
