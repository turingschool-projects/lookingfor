namespace :fix_location do
  desc "fix locations currently in the database"

  task fix_locations: :environment do
    jobs_with_locations
  end

  def jobs_with_locations
    stackoverflow_jobs = Job.where('url LIKE ?', '%stackoverflow%').limit(200)
    stackoverflow_jobs.each do |job|
      if job.location.nil?
        check_for_location(job)
      else
        response = Geocoder.search(job.location)
        sleep 0.25
        if response.empty? || response.count > 1 || check_edge_cases(job.location)
          check_for_location(job)
        end
      end
    end
  end

  def check_for_location(job)
    regex = Regexp.new('\(([^\)]+)\)', 'g')
    potential_locations = job.title.scan(regex).flatten
    potential_locations.each do |p_loc|
      response = Geocoder.search(p_loc)
      sleep 0.25
      if !response.empty? && response.count == 1 && !check_edge_cases(p_loc)
        return job.update_attributes(location: p_loc)
      else
        job.update_attributes(location: nil)
      end
    end
  end

  def check_edge_cases(job_location)
    locations = ["via Andiamo",
                 ".Net",
                 "Early Employee",
                 "Berlin or Slack",
                 "Cloud Foundry",
                 "Core Services",
                 "Pivotal Labs"]
    locations.any? { |location| job_location.include?(location) }
  end
end
