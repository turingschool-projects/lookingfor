class Api::V1::JobsController < ApplicationController

  def last_two_months
    require "pry"; binding.pry
    render json: Job.last_two_months
  end

  def index
    paginate json: Job.by_date, per_page: 25
  end
end
