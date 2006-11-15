class BusinessFormsController < ApplicationController
  layout 'layouts/business_forms'

  def index
    # Index Method for All Business Group related stuff
  end

  def thanks
    # Just a place holder for the THANK YOU template page.
  end

  def travel
    # Present the Travel Request Form
  end

  def travel_request
    # Processes the Travel Request Form
    email = Notifications.deliver_travel(@params['travel'])
    redirect_to :action => "thanks"
  end

  def expense
    # Present the Expense Claims Form
  end

  def freight
    # Present the Freight Request Form
  end

  def freight_request
    # Process the Freight Request Form
    email = Notifications.deliver_freight(@params['freight'])
    redirect_to :action => "thanks"
  end

  def purchase
    # Present the Purchase Request Form
  end

  def purchase_request
    # We process the Purchase Request Form
    email = Notifications.deliver_purchase(@params['purchase'])
    redirect_to :action => "thanks"
  end
  
  def recruitment
    # Present the Recruitment Form
    @inductionmemo = [["Yes", "Yes"], ["No", "No"]]
    @requesttype = [["Amendment", "Amendment"], ["Contract", "Contract"], ["Deal Memo", "Deal Memo"]]
    @name_title = [["Mr", "Mr"], ["Ms", "Ms"]]
    @probationaryperiod = [["N/A", "N/A"], ["3 Months", "3 Months"], ["6 Months", "6 Months"]]
    @basis = [["Fixed Term Contract", "Fixed Term Contract"], ["Fulltime Permanent", "Fulltime Permanent"],
      ["Casual", "Casual"], ["Invoice", "Invoice"]]
    @group = [["BUS", "Business"], ["CLI", "Client"], ["HR", "Human Resources"], 
      ["MAN", "Management"], ["TEC", "Technology"], ["VFX", "VFX"]]
    @entity = [["Corporate", "Corporate"], ["Sole Trader", "Sole Trader"], ["Individual", "Individual"], ["Overseas Consultant", "Overseas Consultant"]]
    @level = [["Trainee", "Trainee"], ["1", "1"], ["2", "2"], ["3", "3"], ["4", "4"]]
    @location = [["Sydney", "Sydney"], ["Adelaide", "Adelaide"], ["Other", "Other"]]
    @rate_period = [["Per Hour", "Per Hour"], ["Per Day", "Per Day"], ["Per Week", "Per Week"], ["Per Annum", "Per Annum"]]
    @visa = [["No", "No"], ["457", "457"], ["ETA", "ETA"], ["Spouse", "Spouse"]]
  end
  
  def recruitment_request
    # We process the Recruitment Form
    email = Notifications.deliver_recruitment(@params['recruitment'])
    if @params['recruitment']['inductionmemo'] == "Yes"
      induction_email = Notifications.deliver_induction_memo(@params['recruitment'])
    end
    redirect_to :action => "thanks"
  end
  
  def leave
    # Present the Leave Request form
    @office = [["Sydney", "Sydney"], ["Adelaide", "Adelaide"]]
    @leave_options = [["Annual", "Annual"], ["TOIL", "TOIL"], ["Sick", "Sick"], ["Parental", "Parental"],
      ["Other", "Other"]]
    @groups =   [["TECH", "TECH"], ["VFX", "VFX"], ["CLI", "CLI"], ["BUS", "BUS"],
                  ["MAN/MKT", "MAN/MKT"], ["HR", "HR"]]
  end
  
  def leave_request
    # We use this to map the group to the person that should receive the
    # emails. HR and VFX are the studio managers so it depends on the 
    # office selected and not the head of the group.
    @map_group_head = {
      "TECH"    => "bruno.mattarollo@rsp.com.au",
      "VFX"     => "",
      "CLI"     => "james.whitlam@rsp.com.au",
      "BUS"     => "remco.marcelis@rsp.com.au",
      "MAN/MKT" => "didier.elzinga@rsp.com.au",
      "HR"      => ""
    }
    # We process the Leave Request form
    calendar = Icalendar::Calendar.new
    event = Icalendar::Event.new
    event.user_id = "tech@rsp.com.au"
    event.timestamp = DateTime.now
    event.start = @params['leave']['fromdate'].to_date
    event.end = @params['leave']['todate'].to_date
    event.summary = @params['leave']['requester']
    calendar.add event
    @params['leave']['icalendar_event'] = calendar.to_ical
    if @params['leave']['office'] == "Sydney" and (@params['leave']['group'] == "VFX" or @params['leave']['group'] == "HR")
      recipients = ["lara.hopkins@rsp.com.au", "jennifer.mcnamara@rsp.com.au"]
    elsif @params['leave']['office'] == "Adelaide" and (@params['leave']['group'] == "VFX" or @params['leave']['group'] == "HR")
      recipients = ["didier.elzinga@rsp.com.au", "caroline.grubb@rsp.com.au"]
    elsif !(@params['leave']['group'] == "HR" or @params['leave']['group'] == "VFX")
      recipients = [@map_group_head[@params['leave']['group']]]
    else
      recipients = ["bruno.mattarollo@rsp.com.au"]
    end
    email = Notifications.deliver_leave(@params['leave'], recipients)
    redirect_to :action => "thanks"
  end
  
  def meeting_room
    # This is just for the form
    @office = [["Sydney", "Sydney"], ["Adelaide", "Adelaide"]]
    @room = [["SYD meeting room", "SYD meeting room"], ["ADL Board Room", "ADL Board Room"],
              ["ADL Meeting room 1", "ADL Meeting room 1"], ["ADL Meeting room 2", "ADL Meeting room 2"]]
  end
  
  def meeting_room_request
    # We get the date
    #   @params['meetingroom']['date'] = '2006-03-16'
    # and time
    #   @params['starttime']['hour'] = 12
    #   @params['starttime']['minute'] = 45
    
    # We process the meeting room request and create the iCal file
    # Let's first assign dates and times to more conveniently named
    # variables
    meeting_date = @params['meetingroom']['date']
    meeting_year = meeting_date.split('-')[0].to_i
    meeting_month = meeting_date.split('-')[1].to_i
    meeting_day = meeting_date.split('-')[2].to_i
    start_hour = @params['starttime']['hour'].to_i
    start_min = @params['starttime']['minute'].to_i
    end_hour = @params['endtime']['hour'].to_i
    end_min = @params['endtime']['minute'].to_i
    start_time = DateTime.civil(meeting_year, meeting_month, meeting_day, start_hour, start_min)
    end_time = DateTime.civil(meeting_year, meeting_month, meeting_day, end_hour, end_min)
    calendar = Icalendar::Calendar.new
    event = Icalendar::Event.new
    event.user_id = "tech@rsp.com.au"
    event.timestamp = DateTime.now()
    event.start = start_time
    event.end = end_time
    event.summary = @params['meetingroom']['title']
    calendar.add event
    @params['meetingroom']['icalendar_event'] = calendar.to_ical
    # Quick little hack to put the values of the time_select in the right
    # Hash
    @params['meetingroom']['starttime'] = @params['starttime']['hour'] + ":" + @params['starttime']['minute']
    @params['meetingroom']['endtime'] = @params['endtime']['hour'] + ":" + @params['endtime']['minute']
    email = Notifications.deliver_meeting_room(@params['meetingroom'])
    redirect_to :action => "thanks"
  end

end
