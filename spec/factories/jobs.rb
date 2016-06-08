FactoryGirl.define do
  factory :job do
    sequence(:title, 1) { |n| [Faker::Company.profession, n].join }
    description { Faker::Company.bs }
    url { Faker::Internet.url }
    location { "New York, NY" }
    posted_date { Faker::Date.between(2.days.ago, Date.today) }
    raw_technologies { [[Faker::Hacker.adjective, Faker::Hacker.noun].join(' '),
                      [Faker::Hacker.adjective, Faker::Hacker.noun].join(' '),
                      Faker::Hacker.abbreviation] }
    remote false
    company
  end

  factory :job_with_location do
    sequence(:title, 1) { |n| [Faker::Company.profession, n].join }
    description { Faker::Company.bs }
    url { Faker::Internet.url }
    location { "Bayonne, NJ" }
    posted_date { Faker::Date.between(2.days.ago, Date.today) }
    raw_technologies { [[Faker::Hacker.adjective, Faker::Hacker.noun].join(' '),
                      [Faker::Hacker.adjective, Faker::Hacker.noun].join(' '),
                      Faker::Hacker.abbreviation] }
    remote false
    company
  end
end
