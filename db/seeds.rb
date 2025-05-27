# db/seeds.rb
puts 'Seeding data...'

# ---- Admin ユーザー ----
AdminUser.where(email: 'admin@example.com').first_or_create!(
  password:              'password',
  password_confirmation: 'password'
)

# ---- テストユーザー10件 ----
User.create!(
  email:                 'test@example.com',
  user_name:             'tester',
  password:              'password123',
  password_confirmation: 'password123',
  confirmed_at:          Time.current  # テスト用に即確認済み
)

end

puts 'Done.'
