require File.expand_path('./config/environment')
require 'elasticsearch'

client = Elasticsearch::Client.new log: true

jobs = Job.last_two_months

jobs.each do |job|
  client.index(index: "looking-for",
               type: "job",
               id: job.id,
               body: {title: job.title,
                     description: job.description,
                     url: job.url,
                     location: job.location,
                     posted_date: job.posted_date,
                     remote: job.remote,
                     technologies: job.raw_technologies,
                     company: Company.find(job.company_id).name})
end
