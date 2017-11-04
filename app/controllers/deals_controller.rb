class DealsController < ApplicationController
  def index
    @deals = Deal.all
    @last_updated = @deals.last.created_at.in_time_zone("Pacific Time (US & Canada)") 
  end
end
