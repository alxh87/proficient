require 'twilio-ruby'

class TwilioController < ApplicationController
  include Webhookable
  
  after_filter :set_header
  skip_before_action :verify_authenticity_token

  def voice_receive
  	if within_office_hours?
      response = Twilio::TwiML::Response.new do |r|
    	  r.Gather :numDigits => '1', :action => voice_menu_path, :method => 'get' do |g|
    	    g.Play 'https://www.dropbox.com/s/cc4xdm963tgxu85/Proficient_voice_vinoo.mp3?dl=1'
    	  end
    	end
    elsif verified_sender?(params["From"])
      response = Twilio::TwiML::Response.new do |r|
        r.Gather :numDigits => '1', :action => voice_menu_path, :method => 'get' do |g|
          r.Say "Sorry, our office hours are Monday to Friday, 9 A M to 5 P M. Please call back later or press 9 to change active numbers."
        end
      end
    else
      response = Twilio::TwiML::Response.new do |r|
        if endtime.to_i > 12
          r.Say "Sorry, our office hours are Monday to Friday, #{starttime} A M to #{(endtime.to_i - 12).to_s} P M.... Please leave a message."
        else
          r.Say "Sorry, our office hours are Monday to Friday, #{starttime} A M to #{endtime} P M.... Please leave a message."
        end
        r.Record maxLength: '20', transcribe: true, transcribeCallback: "http://twimlets.com/voicemail?Email=alxh87@gmail.com"      
      end 
    end
    render_twiml response
  end

  def voice_menu
  	redirect_to 'twilio/voice_receive' unless ['1', '2', '9'].include?(params['Digits'])
  	if ['2'].include?(params['Digits'])
  	  response = Twilio::TwiML::Response.new do |r|
  	    p "support"
  	    p current_support_number
  	    r.Dial current_support_number unless current_support_number == ""
  	    r.Say "Sorry, your call could not be answered at this time. Please try again later."
  	  end
  	elsif ['1'].include?(params['Digits'])
  	  response = Twilio::TwiML::Response.new do |r|
  	    p "Sales"
  	    p current_sales_number
  	    r.Dial current_sales_number
  	    r.Say "Sorry, your call could not be answered at this time. Please try again later."
  	  end

  	elsif params['Digits'] == '9'
  	  if verified_sender?(params["From"])
  	    response = Twilio::TwiML::Response.new do |r|
  	      r.Gather :numDigits => '1', :action => voice_change_path, :method => 'post' do |g|
  	        g.Say "Support number is #{current_support_number.gsub(/.{1}(?=.)/, '\0 ')}. To change press 1."
  	        g.Say "Sales number is #{current_sales_number.gsub(/.{1}(?=.)/, '\0 ')}. To change press 2."
  	        end
  	    end
      else
        response = Twilio::TwiML::Response.new do |r|
          r.Say "Sorry, please check the specified number."
        end
  	  end
    else
      response = Twilio::TwiML::Response.new do |r|
        r.Say "Sorry, please check the specified number."
      end
  	end
  	# byebug
  	render_twiml response
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


end