FactoryGirl.define do
  factory :job do
    title { Faker::Company.profession }
    description { Faker::Company.bs }
    url { Faker::Internet.url }
    location { Faker::Address.city }
    posted_date { Faker::Date.between(2.days.ago, Date.today) }
    raw_technologies { [[Faker::Hacker.adjective, Faker::Hacker.noun].join(' '),
                      [Faker::Hacker.adjective, Faker::Hacker.noun].join(' '),
                      Faker::Hacker.abbreviation] }
    company nil
  end
end
