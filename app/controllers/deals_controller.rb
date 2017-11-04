class DealsController < ApplicationController
  def index
    @deals = Deals.all
  end
end
