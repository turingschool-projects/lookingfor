FactoryGirl.define do
  factory :company do
    # Insures a random value for uniqueness
    # http://stackoverflow.com/questions/25068869/factorygirl-faker-same-data-being-generated-for-every-object-in-db-seed-data
    sequence(:name, 1) { |n| [Faker::Company.name, n].join }
  end
end
