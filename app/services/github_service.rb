require 'bunny'
# require 'pry'
# require 'byebug'

class GithubService < JobFetcher
  def self.subscribe_and_create_jobs
    connection = Bunny.new(
                            :host => "experiments.turing.io",
                            :port => "5672",
                            :user => "student",
                            :pass => "PLDa{g7t4Fy@47H"
                            )
    connection.start
    channel = connection.create_channel
    queue = channel.queue("scrapers.to.lookingfor")
    queue.subscribe do |delivery_info, metadata, payload|
      parsed = JSON.parse(payload, symbolize_names: true)
      create_records(format_entries(parsed))
    end

    loop do

    end
  end

  def self.format_entries(parsed)
    { job: {
              title: parsed[:title],
              description: parsed[:description],
              url: parsed[:url],
              posted_date: parsed[:posted_date]
            },
      company: {
              name: find_or_create_company(parsed[:company_name])
      },
      location: {
              name: parsed[:location]
      }
    }
  end

  def self.find_or_create_company(company_name)
    response = Faraday.get("https://localhost:3001/api/v1/companies/find?name=#{company_name}")
    if response.status == 404
      data = {company: { name: company_name }, token: "TurMonLook4" }
      Faraday.post("https://localhost:3001/api/v1/companies", data)
    else
      parsed = JSON.parse(response.body, symbolize_names: true )

    end
  end

end
