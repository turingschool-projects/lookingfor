class Api::V1::JobsController < ApplicationController

  def index
    jobs = params[:technology].nil? ? Job.by_date : Job.by_date.by_tech(params[:technology])
    paginate json: jobs, per_page: 25
  end

  def show
    @job = Job.find(params[:id])
    render json: @job
  end
end
