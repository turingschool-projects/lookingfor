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
        check_for_location(job) if response.empty?
      end
    end
  end

  def check_for_location(job)
    regex = Regexp.new('\(([^\)]+)\)', 'g')
    potential_locations = job.title.scan(regex)
    potential_locations.each do |p_loc|
      response = Geocoder.search(p_loc[0])
      if !response.empty?
        puts "updating job with #{p_loc} location"
        return job.update_attributes(location: p_loc[0])
      else
        job.update_attributes(location: nil)
      end
    end
  end
end
