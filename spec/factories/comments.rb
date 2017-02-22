FactoryGirl.define do
  factory :comment do
    body { Faker::Lorem.paragraph }
    user
    book
  end
end
