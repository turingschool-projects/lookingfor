require 'activerecord-import'

if Rails.env.production?
  t_names = ["ruby", "javascript", "go", "react", "ember", "clojure", "angular", "rails", "python"]

  t_names.each do |name|
    Technology.create(name: name)
  end
end

if Rails.env.development?
  company_number = 12000
  job_number = 30000

  puts "Loading Technology"
  array = []

  #load technologies
  t_names = ["ruby", "javascript", "go", "react", "ember", "clojure", "angular", "rails", "python"]
  t_names.each do |name|
    array << Technology.new(name: name)
  end
  Technology.import(array)


  #load companies
  array = []
  puts "Loading Companies"

  company_number.times do |i|
    array << Company.new(name: Faker::Company.name + i.to_s)
    puts "Added Company  ##{i} to the import array" if i % 1000 == 0
  end
  puts "Starting import...this will take a long time"
  Company.import(array)


  # load jobs
  array =[]
  puts "Loading Jobs"
  job_number.times do |i|
    id = Random.rand(1..company_number)
    job_attrs = {
      title: Faker::Company.profession + i.to_s,
      description: Faker::Lorem.paragraph(15),
      url: Faker::Internet.url,
      location: Faker::Address.city,
      posted_date: Faker::Date.between(2.days.ago, Date.today),
      remote: i % 2 == 0,
      raw_technologies: Technology.pluck(:name).shuffle.take(3),
      company_id: id
    }
    array << Job.new(job_attrs)
    puts "Added Job  ##{i} to the import array" if i % 1000 == 0
  end
  puts "Starting import...this will take a long time"
  Job.import(array)

  Job.find_each do | job |
    job.assign_tech
    job.save
  end
end
