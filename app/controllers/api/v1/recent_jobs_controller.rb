class Api::V1::RecentJobsController < ApplicationController

  def index
    render json: Job.last_two_months
  end
  
end
