require 'nokogiri' # TODO: move to Gemfile

class WeWorkRemotely < JobFetcher
  BASE_URI = "https://weworkremotely.com/categories/2-programming/jobs.rss"

  def self.scrape
    feed = self.pull_feed
    if feed.entries
      entries = self.format_entries(feed.entries)
    end
  end

  def self.format_entries(entries)
    entries.map do |entry|
      formatted_entry = self.format_entry(entry)
    end
  end

  def self.format_entry(entry)
    { job: {
        title: entry.title,
        url: entry.url,
        location: '', # TODO
        raw_technologies: '', # TODO
        description: self.pull_description(entry.summary),
        remote: true,
        posted_date: entry.published
      },
      company: {
        name: self.pull_company_name(entry.title)
      }
    }
  end

  def self.pull_company_name(title)
    regex = /(.*):/
    regex.match(title)[1] rescue ''
  end

  def self.pull_description(summary)
    summary = summary.gsub(/<\/div>|<li>/, " ")
                     .gsub(/&nbsp;/,"")
    description = Nokogiri::HTML(summary).text.split("\n\n\n")[-2]
    self.scrub_description(description)
  end

  def self.scrub_description(description)
    description.gsub(/\n+|\t+/, " ")
               .gsub("\"", "'")
               .split.join(" ")
               .strip
  end

  def self.pull_feed
    url = BASE_URI
    Feedjira::Feed.fetch_and_parse url
  end
end

# -- Testing --

# if __FILE__ == $0
#   require 'feedjira'
#   require 'pry'
#
#   WeWorkRemotely.scrape
# end
