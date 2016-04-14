class CompaniesController < ApplicationController

  def show
    @company = Company.find(params[:id])
    @tech_names = Technology.pluck(:name)
  end
end
