# db/seeds.rb

require 'faker'

puts "Seeding data..."

# ユーザーの作成
User.destroy_all
25.times do
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
100.times do
  Novel.create!(
    title:       Faker::Book.title,
    author_name: Faker::Book.author,            # ← ここを追加！
    body:        Faker::Lorem.paragraphs(number: 5).join("\n\n"),
    status:      :published,
    user:        users.sample
  )
end


puts "Seeding completed."
