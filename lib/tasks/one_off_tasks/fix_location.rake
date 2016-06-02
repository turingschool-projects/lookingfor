namespace :fix_location do
  desc "fix locations currently in the database"

  task all_previous_records: :environment do
    jobs_with_locations
  end

  def jobs_with_locations
    # only target stackoverflow jobs
    # create a rake 
    # Job.where
  end
end
