class Api::V1::TechnologiesController < ApplicationController
  def show
    technology = Technology.find_by(name: params[:name])

    render json: technology.jobs, serializer: TechnologyJobsSerializer, root: :technology
  end
end
