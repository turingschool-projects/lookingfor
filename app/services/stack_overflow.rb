class StackOverflow < JobFetcher
  BASE_URI = "http://stackoverflow.com/jobs/feed?tags="

  def self.scrape(term='ruby')
    feed = self.pull_feed(term)
    if feed.entries.present?
      a = self.format_entries(feed.entries)
    end
  end

  def self.format_entries(entries)
    entries.map do |entry|
      formatted_entry = self.format_entry(entry)
      self.create_records(formatted_entry)
    end
  end

  def self.format_entry(entry)
    {
      title: entry.title,
      url: entry.url,
      company_name: location,
      location: self.pull_company_name(entry.title),
      technologies: entry.categories, #["perl", "python", "ruby", "or-go.-ruby-and", "or-go-experience-is-stron"],
      description: entry.summary,
      remote: self.is_remote?(title),
      published: entry.published
    }
  end

  def self.pull_company_name(title)
    regex = /at (.*?) \(/
    regex.match(title)[1] rescue ''
  end

  def self.pull_location(title)
    regex = /\((.*?)\)/
    regex.match(title)[1] rescue ''
  end

  def self.pull_feed(term)
    url = BASE_URI + term
    Feedjira::Feed.fetch_and_parse url
  end

  def self.is_remote?(title)
    /remote/i === title
  end
end
