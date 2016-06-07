namespace :fix_location do
  desc "fix locations currently in the database"

  task all_previous_records: :environment do
    jobs_with_locations
  end

  def jobs_with_locations
    stackoverflow_jobs = Job.where('url LIKE ?', '%stackoverflow%').all
    stackoverflow_jobs.each do |job|
      unless job.location =~ /(\w*, \w*)/
        normalize_location(job)
      end
    end
  end

  def normalize_location(job)
    if job.title =~ /(\w*, \w*)/
      job.update_attribute(location: job.title[/(\w*, \w*)/])
    elsif job.title.include?('Singapore')
      job.update_attribute(location: "Singapore")
    elsif job.title.include?('Hong Kong')
      job.update_attribute(location: "Hong Kong")
    elsif job.title.include?('remote')
      job.update_attribute(location: nil)
      job.update_attribute(remote: true)
    else
      job.destroy
    end
  end
end
