FactoryGirl.define do
  factory :book do
    title { Faker::Book.unique.title }
    author { Faker::Book.author }
    pub_date { Faker::Date.between(10.years.ago, 10.days.ago) }
    genre { Faker::Book.genre }
    cover { Faker::Placeholdit.image("200x300", 'jpg') }
    synopsis { Faker::Lorem.paragraph }
    language "English"
    edition "First Edition"
    publisher { Faker::Book.publisher }
    avg_score { Faker::Number.decimal(1, 1) }
  end
end
