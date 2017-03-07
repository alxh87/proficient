class CallbackController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def assignment

    instruction = {
      instruction: 'dequeue',
      post_work_activity_sid: ENV['TWILIO_IDLE_SID']
    }
    task_attributes = JSON.parse(params[:TaskAttributes]) if params[:TaskAttributes]
    p "ASSIGNMENTWORKERSTART"
    p task_attributes['worker_call_sid']
    p "ASSIGNMENTWORKEREND"

    WorkerCall.create(callsid: task_attributes['call_sid'], workercallsid: task_attributes['worker_call_sid'])

    render json: instruction
  end

  def events
    task_attributes = JSON.parse(params[:TaskAttributes]) if params[:TaskAttributes]
    event_type = params[:EventType]
    p '====='
    task_sid = params[:TaskSid]

    if ['workflow.timeout', 'task.canceled'].include?(event_type)

      # reservation = wsclient.workspace.tasks.get(task_sid).reservations.list.each do |reservation|
      #   puts reservation.reservation_status
      #   puts reservation.worker_name
      # end

      p worker_call_sid = task_attributes['worker_call_sid']
      @call = client.account.calls.get(worker_call_sid)
      p '---.---.-'
      @call.update(:status => "completed")
      p @call.status

      end_other_workers(task_attributes['call_sid'])
      task_attributes = JSON.parse(params[:TaskAttributes])

      MissedCall.create(
        selected_product: task_attributes['selected_product'],
        phone_number: task_attributes['from']
      )

      redirect_to_voicemail(task_attributes['call_sid']) if event_type == 'workflow.timeout'
    
    # elsif event_type == 'reservation.accepted' 
    #   reservation = client.workspace.tasks.get(task_sid).reservations.list.each do |reservation|
    #     puts reservation.reservation_status
    #     puts reservation.worker_name
    #   end

    elsif event_type == 'worker.activity.update' &&
          params[:WorkerActivityName] == 'Offline'

      worker_attributes = JSON.parse(params[:WorkerAttributes])
      notify_offline_status(worker_attributes['contact_uri'])

    elsif event_type == 'reservation.accepted' 
      end_other_workers(task_attributes['call_sid'])
        # p '++++++++++++++++++'
        # p worker_call_sid = task_attributes['call_sid']
        # @call = client.account.calls.get(worker_call_sid)
        # p '---.---.-'
        # # @call.update(:status => "completed")
        # p @call.status

    end

    render nothing: true
  end


  private

  def redirect_to_voicemail(call_sid)
    email         = ENV['MISSED_CALLS_EMAIL_ADDRESS']
    message       = 'Sorry, All agents are busy. Please leave a message. We\'ll call you as soon as possible'
    url_message   = { Message: message }.to_query
    redirect_url  =
      "http://twimlets.com/voicemail?Email=#{email}&#{url_message}"

    call = client.account.calls.get(call_sid)
    call.redirect_to(redirect_url)
  end

  def notify_offline_status(phone_number)
    message = 'Your status has changed to Offline. Reply with '\
              '"On" to get back Online'
    client.account.messages.create(
      to: phone_number,
      from: ENV['TWILIO_NUMBER'],
      body: message
    )
  end

  def client
    Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
  end

  def wsclient
    Twilio::REST::TaskRouterClient.new(
      ENV['TWILIO_ACCOUNT_SID'],
      ENV['TWILIO_AUTH_TOKEN'],
      ENV['TWILIO_WS_SID']
    )
  end

  def end_other_workers(callsid)
    calls = WorkerCall.where(callsid: callsid)
    if calls
      calls.each do |call|
        if call.workercallsid
          workercall = client.account.calls.get(call.workercallsid)
          puts "ending call" + call.workercallsid
          workercall.update(:status => "completed")
        end
        # call.destroy
      end
    end
  end


end
