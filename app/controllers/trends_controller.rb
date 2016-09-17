class Api::V1::TrendsController < ApplicationController

  def current_openings_technology_count
    @counts = Job.current_openings_technology_count
    render json: @counts
  end
end
