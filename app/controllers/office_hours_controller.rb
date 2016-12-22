class OfficeHoursController < ApplicationController
  before_action :require_login

  def index
  	@startday = ActiveNumber.find(3).number
  	@endday = ActiveNumber.find(4).number
  	@starttime = ActiveNumber.find(5).number
  	@endtime = ActiveNumber.find(6).number
  end

  def set_office_hours
    ActiveNumber.find(3).update(number: params[:startday])
    ActiveNumber.find(4).update(number: params[:endday])
    ActiveNumber.find(5).update(number: params[:starttime])
    ActiveNumber.find(6).update(number: params[:endtime])
    redirect_to office_hours_index_path
  end

end


