FactoryGirl.define do
  factory :location do
    sequence(:name, 1) { |n| [Faker::Address.city, n].join }
  end
end
