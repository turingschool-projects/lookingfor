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
      data = parse(payload)
      formatted_data = find_location_and_format_data(data)
      process_payload(formatted_data)
    end

    loop do
    end
  end

  def self.process_payload(formatted_data)
    conn = Faraday.new("https://localhost:3001/api/v1/companies", { ssl: { verify: false } })
    # response = Faraday.get("https://turingmonocle-staging.herokuapp.com/api/v1/companies/find?name=#{job['company']}")
    response = conn.get("/find?name=#{formatted_data[:company][:name]}")

    if response.status == 404
      company_data = { company: {name: formatted_data[:company][:name]}, location: formatted_data[:location], token: 'TurMonLook4'}
      # post_response = Faraday.post("https://turingmonocle-staging.herokuapp.com/api/v1/companies", company_data)
      post_response = conn.post do |req|
        req.params = company_data
      end

      # if post_response.status == 500
      #   require 'pry'; binding.pry
      # end
      monocle_response = parse(post_response.body)

      company = Company.find_or_create_by!(name: monocle_response[:name])
      company.monocle_id = monocle_response[:id]
      company.save
      job = company.jobs.create!(title: formatted_data[:job][:title], description: formatted_data[:job][:description], url: formatted_data[:job][:url])
      puts "created/found #{company.name} with created #{job.title}"
    else
      parsed_response = parse(response.body)

      company = Company.find_or_create_by!(name: formatted_data[:company][:name])
      company.monocle_id = parsed_response[:company_id]
      company.save!
      company.jobs.create!(title: formatted_data[:job][:title], description: formatted_data[:job][:description], url: formatted_data[:job][:url])
      puts "created #{job.title}"
    end
  end

  def self.find_location_and_format_data(data)
    #Hit google and get location
    #successful hit
    #unscuccessful hit
    company = data[:company][:name]
    location = data[:location][:name]
    #something here to check for location name and if not, default to denver because builtin is the only one that doesn't have it
    conn = Faraday.new("https://maps.googleapis.com/maps/api/place/textsearch/json")

    response = conn.get do |req|
      req.params['query'] = company
      req.params['key'] = ENV['google_maps_key']
      req.params['location'] = location
      req.params['radius'] = '50000'
    end
    parsed_response = parse(response.body)

    if parsed_response[:status] == 'ZERO_RESULTS'
      format_without_address(data)
    else
      address = parse(response.body)[:results].first[:formatted_address]
      format_with_address(data, address)
    end
  end

  def self.format_with_address(data, address)
    address = address.split(',')
    blah = { job: {
        title: data[:job][:title],
        url: data[:job][:url],
        raw_technologies: data[:job][:raw_technologies],
        description: data[:job][:description],
        remote: data[:job][:remote],
        posted_date: data[:job][:published]
      },
      company: {
        name: data[:company][:name]
      },
      location: blah(address)
    }
  end

  def self.format_without_address(data)
    blah = { job: {
        title: data[:job][:title],
        url: data[:job][:url],
        raw_technologies: data[:job][:raw_technologies],
        description: data[:job][:description],
        remote: data[:job][:remote],
        posted_date: data[:job][:published]
      },
      company: {
        name: data[:company][:name]
      },
      location: {
        name: nil
      }
    }
  end

  def self.blah(address)
    if address[2].split[1]
      {
        street_address: address[0],
        city: address[1].strip,
        state: address[2].split.first.strip,
        zip_code: address[2].split[1].strip
      }
    else
      { name: nil }
    end
  end

  def self.parse(data)
    JSON.parse(data, symbolize_names: true)
  end

end
