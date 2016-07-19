class Api::V1::CompaniesController < ApplicationController

  def show
    @company = Company.find(params[:id])
    # jobs = company.jobs.order('posted_date DESC')
    render json: @company
  end
end
