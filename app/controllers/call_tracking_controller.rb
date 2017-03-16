class CallTrackingController < ApplicationController
  skip_before_action :verify_authenticity_token
  

  def forward_call
    Lead.create(lead_params)
    redirect_to twilio_voice_receive_path
    # render text: twilio_response.text
  end

  private

  def twilio_response
    phone_number = lead_source.forwarding_number

    Twilio::TwiML::Response.new do |r|
      r.Dial current_sales_number
    end
  end

  def lead_params
    {
      lead_source: lead_source,
      phone_number: params[:Caller],
      city: params[:FromCity],
      state: params[:FromState],
      # customer_number: params[:From]
    }
  end

  def lead_source
    called_number = GlobalPhone.parse(params[:Called]).country_code+GlobalPhone.parse(params[:Called]).national_string
    source = LeadSource.find_by_incoming_number(called_number)

    unless source
      LeadSource.create(incoming_number: called_number)
      source = LeadSource.find_by_incoming_number(called_number)
    end

    return source
  end

  def current_sales_number
    ActiveNumber.find(2).number
  end


end

