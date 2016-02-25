class WeWorkRemotely < JobFetcher
  BASE_URI = "https://weworkremotely.com/categories/2-programming/jobs.rss"

  DIVS_OR_LIS        = /<\/div>|<li>/
  NONBREAKING_SPACES = /&nbsp;/
  NEWLINES_OR_TABS   = /\n+|\t+/
  ESCAPED_QUOTES     = "\""

  def self.scrape
    feed = self.pull_feed
    if feed.entries.present?
      self.format_entries(feed.entries)
    end
  end

  def self.format_entries(entries)
    entries.map do |entry|
      formatted_entry = self.format_entry(entry)
      self.create_records(formatted_entry)
    end
  end

  def self.format_entry(entry)
    summary = strip_summary(entry.summary)
    description = self.pull_description(summary)

    { job: {
        title: entry.title,
        url: entry.url,
        location: self.pull_location(summary),
        raw_technologies: self.pull_technologies(description),
        description: description,
        remote: true,
        posted_date: entry.published
      },
      company: {
        name: self.pull_company_name(entry.title)
      }
    }
  end


  def self.strip_summary(summary)
    summary = summary.gsub(DIVS_OR_LIS, " ").gsub(NONBREAKING_SPACES,"")
    Nokogiri::HTML(summary).text
  end

  def self.pull_location(summary)
    regex = /Headquarters: (.*)\s* URL/
    regex.match(summary)[1] rescue ''
  end

  def self.pull_technologies(description)
    technologies.select do |tech|
      regex = /\b#{tech}\b/i
      regex.match(description)
    end
  end

  def self.pull_company_name(title)
    regex = /(.*):/
    regex.match(title)[1] rescue ''
  end

  def self.pull_description(summary)
    description = summary.split("\n\n\n")[-2]
    self.scrub_description(description)
  end

  def self.scrub_description(description)
    description.gsub(NEWLINES_OR_TABS, " ").gsub(ESCAPED_QUOTES, "'").split.join(" ").strip
  end

  def self.pull_feed
    url = BASE_URI
    Feedjira::Feed.fetch_and_parse url
  end
end
