class StackOverflow < JobFetcher
  BASE_URI = "http://stackoverflow.com/jobs/feed?tags="

  attr_reader :term

  def initialize(term="ruby")
    @term = term
  end

  def scrape
    feed = pull_feed
    if feed.entries.present?
      format_entries(feed.entries)
    end
  end

  def format_entries(entries)
    entries.map do |entry|
      formatted_entry = self.format_entry(entry)
      create_records(formatted_entry)
    end
  end

  def format_entry(entry)
    { job: {
        title: entry.title,
        url: entry.url,
        location: self.pull_location(entry.title),
        raw_technologies: generate_raw_technologies(entry), #["perl", "python", "ruby", "or-go.-ruby-and", "or-go-experience-is-stron"],
        description: entry.summary,
        remote: self.is_remote?(entry.title),
        posted_date: entry.published
      },
      company: {
        name: self.pull_company_name(entry.title)
      }
    }
  end

  def pull_company_name(title)
    regex = /at (.*?) \(/
    regex.match(title)[1] rescue ''
  end

  def pull_location(title)
    regex = /\((.*?)\)/
    regex.match(title)[1] rescue ''
  end

  def is_remote?(title)
    /remote/i === title
  end

  private

  def generate_raw_technologies(entry)
    entry.categories | [term]
  end

  def pull_feed
    url = BASE_URI + term
    Feedjira::Feed.fetch_and_parse url
  end
end
