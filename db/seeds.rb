require 'activerecord-import'

if Rails.env.production?
  t_names = ["ruby", "javascript", "go", "react", "ember", "clojure", "angular", "rails", "python"]

  t_names.each do |name|
    Technology.create(name: name)
  end
end

if Rails.env.development?
  puts "Starting Technology"
  array = []
  t_names = ["ruby", "javascript", "go", "react", "ember", "clojure", "angular", "rails", "python", "devops"]
  t_names.each do |name|
    array << Technology.new(name: name)
  end
  Technology.import(array)

  array = []
  company_number = 12000
  puts "Starting Companies"
  company_number.times do |i|
    array << Company.new(name: Faker::Company.name + i.to_s)
    puts "Added Company  ##{i} to the import array" if i % 1000 == 0
  end
  puts "Starting import...this will take a long time"
  Company.import(array)

  array =[]
  puts "Starting Jobs"
  30000.times do |i|
    job_attrs = {
      title: Faker::Company.profession + i.to_s,
      description: Faker::Lorem.paragraph(3),
      url: Faker::Internet.url,
      location: Faker::Address.city,
      posted_date: Faker::Date.between(2.days.ago, Date.today),
      remote: i % 2 == 0,
      raw_technologies: Technology.pluck(:name).take(3)
    }
    array << Job.new(job_attrs)
    puts "Added Job  ##{i} to the import array" if i % 1000 == 0
  end
  puts "Starting import...this will take a long time"
  Job.import(array)

  Job.find_each do | job |
    id = Random.rand(1..company_number)
    job.assign_tech
    job.company = Company.find(id)
    job.save
  end
end
