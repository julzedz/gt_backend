# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Create two users
user1 = User.create!(
  email: 'user1@example.com',
  password: 'password_digest',
  first_name: 'John',
  last_name: 'Doe',
  phone_number: '1234567890',
  city: 'New York',
  state: 'NY',
  date_of_birth: '1980-01-01',
  country: 'USA',
  profile_img_path: '/path/to/image1.jpg',
)

user2 = User.create!(
  email: 'user2@example.com',
  password: 'password_digest',
  first_name: 'Jane',
  last_name: 'Doe',
  phone_number: '0987654321',
  city: 'Los Angeles',
  state: 'CA',
  date_of_birth: '1990-01-01',
  country: 'USA',
  profile_img_path: '/path/to/image2.jpg',
)

# Create accounts for the users
Account.create!(
  user_id: user1.id,
  savings_account: 1000.00,
  investment: 2000.00,
  earnings: 300.00,
  stakes: 400.00
)

Account.create!(
  user_id: user2.id,
  savings_account: 2000.00,
  investment: 3000.00,
  earnings: 400.00,
  stakes: 500.00
)
