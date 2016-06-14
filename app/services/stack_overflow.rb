class StackOverflow < JobFetcher
  BASE_URI = "http://stackoverflow.com/jobs/feed?tags="

  attr_reader :term

  def initialize(term="ruby")
    @term = term
  end

  def scrape
    feed = pull_feed
    if feed.present?
      format_entries(feed)
    end
  end

  def format_entries(entries)
    entries.css('item').map do |entry|
      formatted_entry = self.format_entry(entry)
      create_records(formatted_entry)
    end
  end

  def format_entry(entry)
    title = entry.css('title').text
    url_address = entry.css('guid').text
    location = entry.css('location').text
    description = entry.css('description').text
    { job: {
        title: title,
        url: url_address,
        old_location: location,
        raw_technologies: generate_raw_technologies(entry), #["perl", "python", "ruby", "or-go.-ruby-and", "or-go-experience-is-stron"],
        description: description,
        remote: self.is_remote?(title),
        posted_date: entry.css('pubdate').text
      },
      company: {
        name: self.pull_company_name(title)
      },
      location: {
        name: location
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
    entry.css('category').map do |category|
      category.text
    end
  end

  def pull_feed
    url = BASE_URI + term
    Nokogiri::HTML(open(url))
  end
end
