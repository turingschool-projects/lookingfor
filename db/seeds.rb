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
  puts "Starting Companies"
  200000.times do |i|
    array << Company.new(name: Faker::Company.name + i.to_s)
    puts "Added Company  ##{i} to the array" if i % 10000 == 0
  end
  puts "Starting import..."
  Company.import(array)
  first = Company.first.id

  array =[]
  puts "Starting Jobs"
  100.times do |i|
    begin
    job_attrs = {
      title: Faker::Company.profession + i.to_s,
      description: Faker::Lorem.paragraph(3),
      url: Faker::Internet.url,
      location: Faker::Address.city,
      posted_date: Faker::Date.between(2.days.ago, Date.today),
      remote: i % 2 == 0,
      raw_technologies: Technology.pluck(:name).take(3)
    }
    rescue
      puts i
      next
    end
    array << Job.new(job_attrs)
    puts "Added Job  ##{i} to the array" if i % 10000 == 0
  end
  puts "Starting import..."
  Job.import(array)
  i = 0
  Job.find_each do | job |
    job.assign_tech
    job.company = Company.find(((first + i) % first) + first)
    job.save
    i += 1
    binding.pry
  end
end
