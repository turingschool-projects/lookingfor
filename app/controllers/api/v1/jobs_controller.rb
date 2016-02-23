class Api::V1::JobsController < ApplicationController
  respond_to :json

  def index
    respond_with Job.by_date
  end
end
