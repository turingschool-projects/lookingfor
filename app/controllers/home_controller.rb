class HomeController < ApplicationController
  def index
    @jobs = Job.paginate(page: params[:page]).order('posted_date DESC').decorate
    @company_count = Company.count
    @tech_names = Technology.pluck(:name)
    # Subscriber.subscribe_and_create_jobs
  end
end
