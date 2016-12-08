class CallforwardController < ApplicationController
  def index
  	@sales = Sale.all
  	@supports = Support.all
  end
end
