namespace :fix_location do
  desc "fix locations currently in the database"

  task all_previous_records: :environment do
    jobs_with_locations
  end

  def jobs_with_locations
    stackoverflow_jobs = Job.where('url LIKE ?', '%stackoverflow%').all
    stackoverflow_jobs.each do |job|
      if job.location =~ /(\w*, \w*)/
        p "location is good"
      else
        p "location is not good"
        normalize_location(job)
      end
    end
    # only target stackoverflow jobs
    # create a rake
    # Job.where
  end

  def normalize_location(job)
    
  end
end
