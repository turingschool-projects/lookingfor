class WeWorkRemotely < JobFetcher
  BASE_URI = "https://weworkremotely.com/categories/2-programming/jobs.rss"

  def self.pull_company_name(title)
    regex = /(.*):/
    regex.match(title)[1] rescue ''
  end

  def self.pull_feed
    url = BASE_URI
    Feedjira::Feed.fetch_and_parse url
  end
end
