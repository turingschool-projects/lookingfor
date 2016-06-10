class Api::V1::RecentJobsController < ApplicationController

  def index
    if params[:location]
      search_location = params[:location]
      jobs_by_location = Job.last_month.by_location(search_location)
      render json: jobs_by_location
    else
      paginate json: Job.last_month, per_page: 25
    end
  end

end
