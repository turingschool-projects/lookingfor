class Api::V1::RecentJobsController < ApplicationController

  def index
    paginate json: Job.last_month, per_page: 25
  end

end
