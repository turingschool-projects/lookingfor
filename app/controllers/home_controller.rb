class HomeController < ApplicationController
  def index
    @job_count = Job.count
    @company_count = Company.count
    @tech_names = Technology.pluck(:name)
  end
end
