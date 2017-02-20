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
      process_payload(job)
    end

    def self.process_payload(job)
      response = Faraday.get("https://turingmonocle-staging.herokuapp.com/api/v1/companies/find?name=#{job['company']}")

      if response.status == 404
        binding.pry
        #create company
        company = { company: {name: job['company']}, token: 'TurMonLook4'}
        response = Faraday.post("https://turingmonocle-staging.herokuapp.com/api/v1/companies", company)
        parsed_response = JSON.parse(response.body)

        
      else
        parsed_response = JSON.parse(response.body)
        binding.pry
        #store the monocle_company_id with the job in lookingfor
      end
    end

    loop do
    end
  end
end
