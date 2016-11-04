class HomeController < ApplicationController
  def index
    @jobs = Job.paginate(page: params[:page]).order('posted_date DESC').decorate
    @company_count = Company.count
    @tech_names = Technology.pluck(:name)
  end

  def send_jobs_email
    # Create the user from params
    @user = User.new(params[:user])
    if @user.save
      # Deliver the signup email
      UserNotifier.send_signup_email(@user).deliver
      redirect_to(@user, :notice => 'User created')
    else
      render :action => 'new'
    end
  end
end
