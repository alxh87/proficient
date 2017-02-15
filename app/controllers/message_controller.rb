class MessageController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def incoming
    command     = params['Body'].downcase
    from_number = params['From']

    if command == 'off'
      status = 'Offline'
      activity_sid = ENV['TWILIO_OFFLINE_SID'] 
      change_status(from_number, activity_sid, status)
    elsif command == 'on'
      status = 'Idle'
      activity_sid = ENV['TWILIO_IDLE_SID']
      change_status(from_number, activity_sid, status) 
    else
      render xml: generate_fail_message
    end
    # byebug
    # worker = client.workspace.workers[from_number][:sid]
    # worker_sid = client.workspace.workers.list(TargetWorkersExpression: "contact_uri == '#{from_number}'").first.sid
    
    # # worker_sid = WorkspaceInfo.instance.workers[from_number][:sid]
    # client
    #   .workspace
    #   .workers
    #   .get(worker_sid)
    #   .update(activity_sid: activity_sid)

    # render xml: generate_confirm_message(status)
  end

  private

  def client
    Twilio::REST::TaskRouterClient.new(
      ENV['TWILIO_ACCOUNT_SID'],
      ENV['TWILIO_AUTH_TOKEN'],
      ENV['TWILIO_WS_SID']
    )
  end

  def change_status(from_number, activity_sid, status)
    # byebug
    # worker = client.workspace.workers[from_number][:sid]
    worker_sid = client.workspace.workers.list(TargetWorkersExpression: "contact_uri == '#{from_number}'").first.sid
    
    # worker_sid = WorkspaceInfo.instance.workers[from_number][:sid]
    client
      .workspace
      .workers
      .get(worker_sid)
      .update(activity_sid: activity_sid)

    render xml: generate_confirm_message(status)
  end


  def generate_confirm_message(status)
    Twilio::TwiML::Response.new do |r|
      r.Message "Your status has changed to #{status}"
    end.to_xml
  end

  def generate_fail_message
    Twilio::TwiML::Response.new do |r|
      r.Message "Sorry, your request could not be processed. Please reply 'on' or 'off' to set your current status"
    end.to_xml
  end


end
