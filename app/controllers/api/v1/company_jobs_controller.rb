class Api::V1::CompanyJobsController < ApplicationController
  def index
    jobs = Company.find_by(monocle_id: params[:monocle_id]).jobs
    if jobs
      render json: jobs, status: 200
    else
      render json: {error: "Query error"}, status: 500
    end
  end
end
