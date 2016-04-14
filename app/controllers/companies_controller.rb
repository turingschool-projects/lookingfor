class CompaniesController < ApplicationController

  def show
    @company = Company.find(params[:id])
    jobs = Company.find(params[:id]).jobs
    @jobs = jobs.order('posted_date DESC')
                .paginate(page: params[:page])
                .per_page(10)
                .decorate
  end
end
