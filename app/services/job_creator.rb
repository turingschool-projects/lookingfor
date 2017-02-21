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
        #create company then create the job
        company_data = { company: {name: job['company']}, token: 'TurMonLook4'}
        post_response = Faraday.post("https://turingmonocle-staging.herokuapp.com/api/v1/companies", company)
        monocle_response = JSON.parse(post_response.body)

        company = Company.create!(name: monocle_response['name'], monocle_id: monocle_response['id'])
        company.jobs.create!(title: job['title'], description: job['description'])
        puts "great, congrats!"
      else
        parsed_response = JSON.parse(response.body)
        #store the monocle_company_id with the job in lookingfor
        company = Company.find_or_create_by(name: job['company'], monocle_id: parsed_response['company_id'])
        company.jobs.create!(title: job['title'], description: job['description'])
      end
    end

    loop do
    end
  end
end
