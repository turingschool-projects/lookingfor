class StackOverflow
  BASE_URI = "http://stackoverflow.com/jobs/feed?tags="

  def self.scrape(term='ruby')
    url = BASE_URI + term
    feed = Feedjira::Feed.fetch_and_parse url
    if feed.entries.present?
      a = self.format_entries(feed.entries)
    end
  end

  def self.format_entries(entries)
    self.format_entry(entries.first)
    # entries.map do |entry|
      # self.format_entry
    # end
  end

  def self.format_entry(entry)
    {
      title: entry.title, #"Principal Software Engineer at Comcast (Philadelphia, PA)"
      company_name: self.pull_company_name(entry.title),
      url: entry.url,
      location: pull_location(entry.title),
      technologies: entry.categories, #["perl", "python", "ruby", "or-go.-ruby-and", "or-go-experience-is-stron"],
      description: entry.summary,
      published: entry.published
    }

    # Create or find a company
      # Set company id on job

   # Create job with
  end

  def self.pull_company_name(title)
    regex = /at (.*?) \(/
    regex.match(title)[1] rescue ''
  end

  def self.pull_location(title)
    regex = /\((.*?)\)/
    regex.match(title)[1] rescue ''
  end
end
