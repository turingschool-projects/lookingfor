class HomeController < ApplicationController
  def index
    @job_count = Job.count
    @jobs = Job.paginate(page: params[:page]).order('posted_date DESC')
    @company_count = Company.count
    @tech_names = Technology.pluck(:name)
  end
end
