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
      data = parse(payload)
      formatted_data = find_location_and_format_data(data)
      process_payload(formatted_data)
    end

    loop do
    end
  end

  def self.process_payload(formatted_data)
    response = conn.get("/api/v1/companies/find?name=#{formatted_data[:company][:name]}")
    parsed_response = parse(response.body)

    if response.status == 404 && parsed_response[:error] == "company not found"
      create_monocle_company(formatted_data)
    else
      create_job_from_found_company(formatted_data, parsed_response[:company_id])
    end
  end

  def self.create_job_from_found_company(formatted_data, company_id)
    company = create_company(formatted_data[:company][:name], company_id)
    job = company.jobs.create!(title: formatted_data[:job][:title], description: formatted_data[:job][:description], url: formatted_data[:job][:url])
    puts "created #{job.title}"
  end

  def self.create_monocle_company(formatted_data)
    monocle_response = post_to_monocle(formatted_data)
    company = create_company(monocle_response[:name], monocle_response[:id])
    job = company.jobs.create!(title: formatted_data[:job][:title], description: formatted_data[:job][:description], url: formatted_data[:job][:url])
    puts "created/found #{company.name} with created #{job.title}"
  end

  def self.post_to_monocle(formatted_data)
    company_data = { company: {name: formatted_data[:company][:name]}, location: formatted_data[:location], token: 'TurMonLook4'}

    post_response = conn.post do |req|
      req.url '/api/v1/companies'
      req.params = company_data
    end

    parse(post_response.body)
  end

  def self.conn
    Faraday.new("https://0.0.0.0:3002", { ssl: { verify: false } })
  end

  def self.create_company(company_name, company_id)
    company = Company.find_or_create_by!(name: company_name)
    company.monocle_id = company_id
    company.save
    company
  end

  def self.find_lat_lng(data)
    company = data[:company][:name]
    location = data[:location][:name]

    response = Faraday.get("https://maps.googleapis.com/maps/api/geocode/json?address=#{location}&key=#{ENV['google_maps_key']}")
    parsed_lat_lng = parse(response.body)
    lat_lng = parsed_lat_lng[:results][0][:geometry][:location]
    "#{lat_lng[:lat]},#{lat_lng[:lng]}"
  end

  def self.find_location_and_format_data(data)
    company = data[:company][:name]
    location = data[:location][:name]

    if location != ""
      conn = Faraday.new("https://maps.googleapis.com/maps/api/place/textsearch/json")

      response = conn.get do |req|
        req.params['query'] = company
        req.params['key'] = ENV['google_maps_key']
        req.params['location'] = find_lat_lng(data)
        req.params['radius'] = '50000'
      end

      parsed_response = parse(response.body)

      if parsed_response[:status] == 'ZERO_RESULTS'
        format_without_address(data)
      else
        address = parse(response.body)[:results].first[:formatted_address]
        format_with_address(data, address)
      end
    else
      format_without_address(data)
    end
  end

  def self.format_with_address(data, address)
    address = address.split(',')
    { job: {
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
      location: address_determination(address)
    }
  end

  def self.format_without_address(data)
    { job: {
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

  def self.address_determination(address)
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
