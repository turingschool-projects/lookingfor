class Api::V1::LocationSearchController < ApplicationController

  def index
    location = params[:location]
    render json: Job.where("lower(location) LIKE ?", "%#{location.downcase}%").count
  end

end
