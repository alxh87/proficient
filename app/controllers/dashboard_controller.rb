class DashboardController < ApplicationController
	before_action :require_login

	
  def index
    @lead_sources = LeadSource.all
    @leads = Lead.all
  end
end
