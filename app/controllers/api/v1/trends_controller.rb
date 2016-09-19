class Api::V1::TrendsController < ApplicationController

  def current_openings_technology_count
    render json: Job.current_openings_technology_count
  end
end
