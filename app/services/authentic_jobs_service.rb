class AuthenticJobsService < JobFetcher
  def self.scrape(term)
    jobs = self.get_jobs(term)
    self.format_and_create_entries(jobs, term)
  end

  def self.format_and_create_entries(entries, term)
    entries.each do |entry|
      formatted_entry = self.format_entry(entry, term)
      self.create_records(formatted_entry) unless entry[:company].nil?
    end
  end

  def self.format_entry(entry,term)
    { job: {
        title: self.full_title(entry),
        url: entry[:url],
        location: self.pull_location(entry),
        raw_technologies: self.pull_technologies(entry[:description], term),
        description: entry[:description],
        remote: entry[:telecommuting] == 1 ? true : false,
        posted_date: entry[:post_date]
      },
      company: {
        name: self.pull_company_name(entry)
      }
    }
  end

  def self.full_title(entry)
    if !entry[:company].nil?
      "#{entry[:title]} at #{self.pull_company_name(entry)} (#{self.pull_location(entry)})"
    else
      entry[:title]
    end
  end

  def self.pull_location(entry)
    if !entry[:company].nil? && !entry[:company][:location].nil?
      entry[:company][:location][:name]
    elsif entry[:telecommuting] == 1
      "Remote"
    else
      ""
    end
  end

  def self.pull_company_name(entry)
    entry[:company].nil? ? "" : entry[:company][:name]
  end

  def self.pull_technologies(description, term)
    tech = technologies.select do |tech|
      regex = /\b#{tech}\b/i
      regex.match(description)
    end
    tech.empty? ? [term] : tech
  end

  def self.get_jobs(term)
    response = self.parse(connect_to_authentic_jobs.get("?keywords=#{term}"))
    response[:listings].nil? ? [] : response[:listings][:listing]
  end

  def self.connect_to_authentic_jobs
    connection = self.initial_connection
    connection.params['api_key'] = ENV['AUTHENTIC_JOBS_KEY']
    connection.params['format'] = 'json'
    connection.params['method'] = 'aj.jobs.search'
    connection.params['perpage'] = '100'
    connection
  end

  def self.initial_connection
    Faraday.new(url: "https://authenticjobs.com/api/")
  end

  private

    def self.parse(response)
      JSON.parse(response.body, symbolize_names: true)
    end
end
