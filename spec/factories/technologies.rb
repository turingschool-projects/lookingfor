FactoryGirl.define do
  factory :technology do
    sequence(:name, 1) { |n| [Faker::Company.catch_phrase, n].join }
  end
end
