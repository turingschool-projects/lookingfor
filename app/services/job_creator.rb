class JobCreator
  def self.start
    connection = Bunny.new(
      :host => 'monocle.turing.io',
      :port => '5672',
      :user => 'monocle',
      :pass => 'RzoCoV7GR2wGAb'
    )

    connection.start
    channel = connection.create_channel
    queue = channel.queue('scrapers.to.lookingfor')

    queue.subscribe do |delivery_info, metadata, payload|
      puts "I hit the queue!"
      job = JSON.parse(payload)
      job_with_location = find_location(job)
      process_payload(job_with_location)
    end

    loop do
    end
  end

  def self.process_payload(job)
    conn = Faraday.new("https://turingmonocle-staging.herokuapp.com/api/v1/companies", { ssl: { verify: false } })
    # response = Faraday.get("https://turingmonocle-staging.herokuapp.com/api/v1/companies/find?name=#{job['company']}")
    response = conn.get("/find?name=#{job['company']}")

    if response.status == 404
      company_data = { company: {name: job['company']}, token: 'TurMonLook4'}
      # post_response = Faraday.post("https://turingmonocle-staging.herokuapp.com/api/v1/companies", company_data)
      post_response = conn.post do |req|
        req.params = company_data
      end

      # if post_response.status == 500
      #   require 'pry'; binding.pry
      # end
      monocle_response = JSON.parse(post_response.body)

      company = Company.find_or_create_by!(name: monocle_response['name'])
      company.monocle_id = monocle_response['id']
      company.save
      job = company.jobs.create!(title: job['title'], description: job['description'], url: job['url'])
      puts "created/found #{company.name} with created #{job.title}"
    else
      parsed_response = JSON.parse(response.body)

      company = Company.find_or_create_by!(name: job['company'])
      company.monocle_id = parsed_response['company_id']
      company.save!
      company.jobs.create!(title: job['title'], description: job['description'], url: job['url'])
      puts "created #{job.title}"
    end
  end

  def self.find_location(job)

    #Hit google and get location
    #successful hit
    #unscuccessful hit
    query = job["company"]

    conn = Faraday.new("https://maps.googleapis.com/maps/api/place/textsearch/json")
    respone = conn.get do |req|
      req.params['query'] = query
      req.params['key'] = ENV['google_maps_key']
      req.params['location'] = 'Denver'
      req.params['radius'] = '500'
    end
    binding.pry
  end

  # def self.format(located_job)
  #
  # end
end
