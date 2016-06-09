class Api::V1::LocationSearchController < ApplicationController

  def index
    search_location = params[:location]
    jobs_by_location = Job.last_month.by_location(search_location)
    render json: jobs_by_location
  end

end
