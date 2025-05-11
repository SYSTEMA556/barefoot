# db/seeds.rb

require 'faker'

puts "Seeding data..."

# ユーザーの作成
User.destroy_all
5.times do
  User.create!(
    user_name: Faker::Name.unique.name,
    email: Faker::Internet.unique.email,
    password: 'password',
    password_confirmation: 'password',
    confirmed_at: Time.current
  )
end

# 小説の作成
Novel.destroy_all
users = User.all
10.times do
  Novel.create!(
    title: Faker::Book.title,
    body: Faker::Lorem.paragraphs(number: 5).join("\n\n"),
    user: users.sample
  )
end

puts "Seeding completed."
