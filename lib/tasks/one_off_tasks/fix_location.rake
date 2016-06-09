namespace :fix_location do
  desc "fix locations currently in the database"

  task fix_locations: :environment do
    jobs_with_locations
  end

  def jobs_with_locations
    stackoverflow_jobs = Job.where('url LIKE ?', '%stackoverflow%')
    stackoverflow_jobs.each do |job|
      location = Geocoder.search(job.location)
      normalize_location(job) if location.empty?
    end
  end

  def normalize_location(job)
    if job.title =~ /(\w*, \w*)/
      location = job.title[/\(([^\)]+)\)/]
      response = Geocoder.search(location)
      if !response.empty?
        job.update_attributes(location: location)
      else
        check_for_location(job)
      end
    elsif job.title.include?('Singapore')
      job.update_attributes(location: "Singapore")
    elsif job.title.include?('Hong Kong')
      job.update_attributes(location: "Hong Kong")
    elsif job.title.include?('remote')
      job.update_attribute(remote: true)
      job.update_attribute(location: "remote")
    end
  end

  def check_for_location(job)
    # search other spots for the location
    # possibly some more regex?
  end
end
