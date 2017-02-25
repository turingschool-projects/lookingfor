class JobCreator
  def self.start
    connection = Bunny.new(
      :host => 'experiments.turing.io',
      :port => '5672',
      :user => 'student',
      :pass => 'PLDa{g7t4Fy@47H'
    )

    connection.start
    channel = connection.create_channel
    queue = channel.queue('scrapers.to.lookingfor')

    queue.subscribe do |delivery_info, metadata, payload|
      job = JSON.parse(payload)
      job_with_location = find_location(job)
      process_payload(job_with_location)
    end

    def self.process_payload(job)
      response = Faraday.get("https://turingmonocle-staging.herokuapp.com/api/v1/companies/find?name=#{job['company']}")

      if response.status == 404
        company_data = { company: {name: job['company']}, token: 'TurMonLook4'}
        post_response = Faraday.post("https://turingmonocle-staging.herokuapp.com/api/v1/companies", company_data)
        monocle_response = JSON.parse(post_response.body)

        company = Company.find_or_create_by!(name: monocle_response['name'])
        company.monocle_id = monocle_response['id']
        company.save
        company.jobs.create!(title: job['title'], description: job['description'], url: job['url'])

      else
        parsed_response = JSON.parse(response.body)

        company = Company.find_or_create_by!(name: job['company'])
        company.monocle_id = parsed_response['company_id']
        company.save!
        company.jobs.create!(title: job['title'], description: job['description'], url: job['url'])
      end


      def self.find_location(job)
        #Hit google and get location
        #successful hit
        #unscuccessful hit
      end
    end

    loop do
    end
  end
end
