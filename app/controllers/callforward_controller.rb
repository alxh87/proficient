class CallforwardController < ApplicationController
  def index
  	@sales_numbers = SalesNumber.all
  	@support_numbers = SupportNumber.all
  	@active_numbers = ActiveNumber.all
  end
end
