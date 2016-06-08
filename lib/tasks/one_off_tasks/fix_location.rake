namespace :fix_location do
  desc "fix locations currently in the database"

  task fix_locations: :environment do
    jobs_with_locations
  end

  def jobs_with_locations
    stackoverflow_jobs = Job.where(latitude: nil)
    stackoverflow_jobs.each do |job|
        normalize_location(job)
    end
  end

  def normalize_location(job)
    if job.title =~ /(\w*, \w*)/
      location = job.title[/\(([^\)]+)\)/]
      job.update_attributes(location: location)
    elsif job.title.include?('Singapore')
      job.update_attributes(location: "Singapore")
    elsif job.title.include?('Hong Kong')
      job.update_attributes(location: "Hong Kong")
    elsif job.title.include?('remote')
      job.update_attribute(remote: true)
      job.update_attribute(location: "remote")
    else
      job.destroy
    end
  end
end
