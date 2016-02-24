class Api::V1::JobsController < ApplicationController
  # respond_to :json

  def index
    paginate json: Job.by_date, per_page: 25
  end
end
