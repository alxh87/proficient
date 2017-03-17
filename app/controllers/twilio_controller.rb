require 'twilio-ruby'

class TwilioController < ApplicationController
  include Webhookable
  
  after_filter :set_header
  skip_before_action :verify_authenticity_token

  def voice_receive
    

      response = Twilio::TwiML::Response.new do |r|
    	  r.Gather :numDigits => '1', :action => voice_menu_path, :method => 'get' do |g|
    	    g.Play 'https://www.dropbox.com/s/cmxrj3bf80meidc/vinoovoicetrim.mp3?dl=1'
    	  end
    	end
      # if verified_sender?(params["From"])
      #   response = Twilio::TwiML::Response.new do |r|
      #     r.Gather :numDigits => '1', :action => voice_menu_path, :method => 'get' do |g|
      #       r.Say "Sorry, our office hours are Monday to Friday, 9 A M to 5 P M."
      #     end
      #   end
      # end

    render_twiml response
  end

  def voice_menu
    p params
    if ['1', '2'].include?(params['Digits'])
  	# redirect_to twilio_voice_receive_path unless ['1', '2'].include?(params['Digits'])
      digits = params[:Digits]
    	if digits == '2'
        # p '2222'
        area = "Operations"
        p area
    	  response = Twilio::TwiML::Response.new do |r|
    	    r.Enqueue workflowSid: ENV['TWILIO_WORKFLOW_SID'] do |e|
            e.Task "{\"selected_area\": \"#{area}\"}"
          end
    	  end
    	elsif digits == '1'
        # lead = Lead.create(lead_params)
        p '1111'
        if within_office_hours?
          # p "withinoffice"
          area = "Sales"
          p area
          # p '==========='
          # p ENV['TWILIO_WORKFLOW_SID']
          # p'+++++++++++++'
      	  response = Twilio::TwiML::Response.new do |r|
      	    r.Enqueue workflowSid: ENV['TWILIO_WORKFLOW_SID'] do |e|
              e.Task "{\"selected_area\": \"#{area}\"}"
            end
      	  end
        else
          MissedCall.create(
            selected_product: task_attributes['selected_product'],
            phone_number: task_attributes['from']
          )
          response = Twilio::TwiML::Response.new do |r|
            if endtime.to_i > 12
              r.Say "Sorry, our office hours are Monday to Friday, #{starttime} A M to #{(endtime.to_i - 12).to_s} P M.... Please leave a message."
            else
              r.Say "Sorry, our office hours are Monday to Friday, #{starttime} A M to #{endtime} P M.... Please leave a message."
            end
            r.Record maxLength: '20', transcribe: true, transcribeCallback: "http://twimlets.com/voicemail?Email=#{ENV['MISSED_CALLS_EMAIL_ADDRESS']}"      
          end 
        end
      else
        response = Twilio::TwiML::Response.new do |r|
          r.Say "Sorry, please check the specified number."
        end
    	end
    	# byebug
    	render_twiml response
    else
        return redirect_to twilio_voice_receive_path
    end
  end


  def voice_change
  	redirect_to 'twilio/voice_receive' unless ['1', '2'].include?(params['Digits'])
  	if params['Digits'] == '1'
  	  response = Twilio::TwiML::Response.new do |r|
  	    r.Gather :numDigits => '1', :action => support_change_path, :method => 'post' do |g|
  	      g.Say "To change support number."
  	      support_number_list.each_with_index do |n,i|
  	        g.Say "Press #{i+1} for #{n.number.gsub(/.{1}(?=.)/, '\0 ')}"
  	      end
  	    end
  	  end
  	else
  	  response = Twilio::TwiML::Response.new do |r|
  	    r.Gather :numDigits => '1', :action => sales_change_path, :method => 'post' do |g|
  	      g.Say "To change sales number."
  	      sales_number_list.each_with_index do |n,i|
  	        g.Say "Press #{i + 1} for #{n.number.gsub(/.{1}(?=.)/, '\0 ')}"
  	      end
  	    end
  	  end
  	end

    render_twiml response

  end

  def voice_change_support
  	if selection = support_number_list[(params['Digits'].to_i) - 1]
      ActiveNumber.update(1, name: selection.name, number: selection.number)
  	  response = Twilio::TwiML::Response.new do |r|
  	    r.Say "Support number has been changed to #{current_support_number.gsub(/.{1}(?=.)/, '\0 ')}. Have a nice day"
  	  end

  	else
  	  response = Twilio::TwiML::Response.new do |r|
  	    r.Say "Sorry, please check the specified number."
  	  end
  	end
  	render_twiml response
  end

  def voice_change_sales
    if selection = sales_number_list[(params['Digits'].to_i) - 1]
      ActiveNumber.update(2, name: selection.name, number: selection.number)
      response = Twilio::TwiML::Response.new do |r|
        r.Say "Sales number has been changed to #{current_support_number.gsub(/.{1}(?=.)/, '\0 ')}. Have a nice day"
      end

    else
      response = Twilio::TwiML::Response.new do |r|
        r.Say "Sorry, please check the specified number."
      end
    end
    render_twiml response
  end

  private

  def current_support_number
  	ActiveNumber.find(1).number
  end

  def current_sales_number
  	ActiveNumber.find(2).number
  end


  def support_number_list
  	SupportNumber.order(:id)
  end

  def sales_number_list
  	SaleNumber.order(:id)

  end

  def active_number_list
    ActiveNumber.order(:id)
  end

  def verified_sender?(sender)
    nums=SupportNumber.pluck(:number)|SalesNumber.pluck(:number)
    nums<<'+61405454187'  #alex
    nums<<'+61407027118'  #juarez
    nums<<'+61421792096'  #jordan
    nums.include?(sender)
  end

  def startday
    OfficeHour.find(1).number
  end

  def endday
    OfficeHour.find(2).number
  end

  def starttime
    OfficeHour.find(3).number
  end

  def endtime
    OfficeHour.find(4).number
  end


  def within_office_hours?
    (startday.to_i..endday.to_i).cover?(Time.now.wday)&(starttime.to_i..endtime.to_i).cover?(Time.now.hour)   #monday(1)-friday(5) AND 9:00-16:59
  end

  def lead_params
    {
      lead_source: lead_source,
      phone_number: params[:Caller],
      city: params[:FromCity],
      state: params[:FromState],
      customer_number: params[:From]
    }
  end

  def lead_source
    incoming_number = GlobalPhone.parse(params[:Called]).country_code+GlobalPhone.parse(params[:Called]).national_string
    LeadSource.find_by_incoming_number(incoming_number)
  end


end