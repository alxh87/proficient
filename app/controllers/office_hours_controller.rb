class OfficeHoursController < ApplicationController
  before_action :require_login

  def index
  	@startday = OfficeHour.find(1).number
  	@endday = OfficeHour.find(2).number
  	@starttime = OfficeHour.find(3).number
  	@endtime = OfficeHour.find(4).number
  end

  def set_office_hours
    OfficeHour.find(1).update(number: params[:startday])
    OfficeHour.find(2).update(number: params[:endday])
    OfficeHour.find(3).update(number: params[:starttime])
    OfficeHour.find(4).update(number: params[:endtime])
    redirect_to office_hours_index_path
  end

end


