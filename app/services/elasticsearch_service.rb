require File.expand_path('./config/environment')
require 'elasticsearch'

client = Elasticsearch::Client.new log: true

# job = Job.first
# client.index(index: "test-jobs", type: "job", id: job.id, body: {title: job.title, description: job.description})
# expand this for everything you want the job to have - no joins table, job just knows it's technologies
# puts job.id

jobs = Job.all
# jobs = Job.first(10)

###### jobs.each do |job|
######   client.index(index: "looking-for", type: "job", id: job.id, body: {title: job.title,
######                                                                      description: job.description,
######                                                                      url: job.url,
######                                                                      location: job.location,
######                                                                      posted_date: job.posted_date,
######                                                                      remote: job.remote,
######                                                                      technologies: job.raw_technologies,
######                                                                      company: Company.find(job.company_id).name})
###### end



# $ curl localhost:9200/looking-for/job/1
# $ curl -XDELETE localhost:9200/looking-for # This drops the whole database. This kills the jobs
# $ ruby app/services/elasticsearch_service.rb

# $ curl 'localhost:9200/looking-for/job/_search?size=700&pretty' -d '{"query": { "bool": { "should": [{ "match": { "title": "infrastructure"}}, { "match": { "description": "infrastructure"}}]}}}'
# ^^ This will return anything matching the term infrastructure in title or description (and give up to 700 results)


# job = jobs.first

# client.search(index: "looking-for", body: { query: { match: {title: "New Relic"}}})
client.search(index: "looking-for",
              body: {
              query: {
              match: {
              title: "infrastructure"}}})
