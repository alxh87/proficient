class CallforwardController < ApplicationController

  before_action :require_login
  
  def index
  	@sales_numbers = sales_number_list
  	@support_numbers = support_number_list
  	@active_numbers = active_number_list
    @current_support_number = current_support_number
    @current_sales_number = current_sales_number
  end

  def set_active_number
    if params[:support_index]
    	new_support = support_number_list[params[:support_index].to_i]
    	ActiveNumber.find(1).update(name: new_support.name, number: new_support.number)
    elsif params[:sales_index]
      new_sales = sales_number_list[params[:sales_index].to_i]
      ActiveNumber.find(2).update(name: new_sales.name, number: new_sales.number)
    end
    redirect_to callforward_index_path
  end

  private

  def support_number_list
  	SupportNumber.order(:id)
  end

  def sales_number_list
  	SalesNumber.order(:id)
  end

  def active_number_list
  	ActiveNumber.order(:id)
  end

  def current_support_number
    ActiveNumber.find(1).number
  end

  def current_sales_number
    ActiveNumber.find(2).number
  end


end
