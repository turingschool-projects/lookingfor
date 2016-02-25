class Api::V1::JobsController < ApplicationController

  def index
    paginate json: Job.by_date, per_page: 25
  end
end
