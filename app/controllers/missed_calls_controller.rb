class MissedCallsController < ApplicationController
	before_action :require_login

	
  def index
    @missed_calls = MissedCall.all
  end

end
