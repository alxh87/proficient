class WorkerController < ApplicationController

  before_action :require_login


  def new
      worker_name = params["name"]
      worker_number = params["number"]
      worker_area = [] 
      worker_area << "Sales" if params["sales"]
      worker_area << "Operations" if params["operations"]
      worker_attributes = "{\"area\": #{worker_area}, \"contact_uri\": \"#{worker_number}\"}"

	    if /\A\+\d{11}\z/ =~ worker_number
        begin
          create_worker(worker_name, worker_attributes)
          redirect_to callforward_index_path, notice: 'New worker created.'
        rescue Twilio::REST::RequestError => e
          redirect_to callforward_index_path, notice: 'Error. ' + e.to_s
        end
      else 
        redirect_to callforward_index_path, notice: 'Error. Please enter number in format +612345678901'
      end
  end


  def update
      worker_sid = params["sid"]
      worker_name = params["name"]
      worker_number = params["number"]
      if params["online"] == '1'
        activity_sid = ENV['TWILIO_IDLE_SID']
      else
        activity_sid = ENV['TWILIO_OFFLINE_SID']
      end
      
      worker_area = [] 
      worker_area << "Sales" if params["sales"]
      worker_area << "Operations" if params["operations"]
      worker_attributes = "{\"area\": #{worker_area}, \"contact_uri\": \"#{worker_number}\"}"
      if /\A\+\d{11}\z/ =~ worker_number
        begin
          update_worker(worker_sid, worker_name, worker_attributes, activity_sid)
          redirect_to callforward_index_path, notice: worker_name.to_s + ' has been updated.'
        rescue Twilio::REST::RequestError => e
          redirect_to callforward_index_path, notice: 'Error. ' + e.to_s
        end
      else 
        redirect_to callforward_index_path, notice: 'Error. Please enter number in format +612345678901'
      end
  end

  def delete
    worker_sid = params["sid"]
    worker_name = params["name"]
    delete_worker(worker_sid)
    redirect_to callforward_index_path, notice: worker_name.to_s + ' has been deleted.'
  end

  private
  
  def create_worker(name, attributes)
    client.workspace.workers.create(
      friendly_name: name,
      attributes:    attributes,
      activity_sid:  ENV['TWILIO_IDLE_SID']
    )
  end

  def update_worker(worker_sid, name, attributes, activity)
    worker = client.workspace.workers.get(worker_sid)
    
    worker = worker.update(
      friendly_name: name,
      attributes:    attributes,
      activity_sid: activity
    )
  end

  def delete_worker(worker_sid)
    worker = client.workspace.workers.get(worker_sid)
    
    worker = worker.update(
      activity_sid: ENV['TWILIO_OFFLINE_SID']
    )
    worker.delete
  end

  def client
    Twilio::REST::TaskRouterClient.new(
      ENV['TWILIO_ACCOUNT_SID'],
      ENV['TWILIO_AUTH_TOKEN'],
      "WS01351c4c695975bd7171282fdad42769"
    )
  end

end
