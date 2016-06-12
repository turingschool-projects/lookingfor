class Api::V1::RecentJobsController < ApplicationController
  def index
    jobs = Job.last_month
    jobs = jobs.merge Job.by_location(params[:location]) if params[:location]
    jobs = jobs.merge Job.by_tech(params[:technology]) if params[:technology]

    paginate json: jobs, per_page: 25
  end
end
