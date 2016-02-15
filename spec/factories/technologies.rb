FactoryGirl.define do
  factory :technology do
    name { Faker::Company.catch_phrase }
  end
end
