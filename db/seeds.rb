# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')

# Users
User.create!(name: 'James Bond',
             email: 'james@bond.com',
             password: '123456',
             password_confirmation: '123456',
             admin: true)

29.times do |n|
  name = Faker::Name.name
  email = Faker::Internet.unique.email
  password = '123456'
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
end


# connections
users = User.all
5.times do |n|
 user = users[n]
 following = users[(n+10)..(n+20)]
 followers = users[(n+5)..(n+15)]
 following.each { |followed| user.followees << followed }
 followers.each { |follower| follower.followees << user }
end


# books
40.times do |n|
  title = Faker::Book.unique.title
  author = Faker::Book.author
  pub_date = Faker::Date.between(10.years.ago, 10.days.ago)
  genre = Faker::Book.genre
  cover = Faker::Placeholdit.image("200x300", 'jpg')
  synopsis = Faker::Lorem.paragraph
  language = "English"
  edition = "First Edition"
  publisher = Faker::Book.publisher
  avg_score = Faker::Number.decimal(1, 1)
  Book.create!(title: title,
               author: author,
               pub_date: pub_date,
               genre: genre,
               cover: cover,
               synopsis: synopsis,
               language: language,
               edition: edition,
               publisher: publisher,
               avg_score: avg_score)
end


# favorites, comments and wishlists
books = Book.all

users.map.with_index do |user, i|
  2.times do |n|
    user.favorite_books << books[n + i]
    user.books_to_read << books[2 + n + i]
    body = Faker::Lorem.paragraph
    Comment.create!(body: body,
                    user_id: user.id,
                    book_id: books[i].id)
  end
end





