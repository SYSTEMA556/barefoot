# db/seeds.rb

puts 'Seeding novels only...'

# ---- ダミー小説データ大量作成 ----
# User や Devise モデルは使わず、Novel のみシードしますわ。
# Faker が使えるならランダム生成、なければ固定パターンで作りますの。

if defined?(Faker)
  # Faker がある場合は 20 件のランダム小説を作成
  20.times do |i|
    title       = Faker::Book.title
    author_name = Faker::Name.name
    body        = Faker::Lorem.paragraph(sentence_count: 5)
    font        = ["こぶり明朝", "游ゴシック", "MS明朝", "ヒラギノ角ゴ", "Shippori Mincho", "Noto Serif JP"].sample
    password    = "novelpass#{i + 1}"

    Novel.create!(
      title:                title,
      author_name:          author_name,
      body:                 body,
      font_choice:          font,
      password:             password,
      password_confirmation: password,
      status:               "published"
    )
    puts "Created Novel: #{title} / #{author_name}"
  end
else
  # Faker がない場合は 10 件の固定ダミー小説を作成
  10.times do |i|
    title       = "ダミー小説#{i + 1}"
    author_name = "ダミー作者#{i + 1}"
    body        = "これはダミーの本文 #{i + 1} です。"
    font        = ["こぶり明朝", "游ゴシック", "MS明朝", "ヒラギノ角ゴ", "Shippori Mincho", "Noto Serif JP"][i % 6]
    password    = "dummypass#{i + 1}"

    Novel.create!(
      title:                title,
      author_name:          author_name,
      body:                 body,
      font_choice:          font,
      password:             password,
      password_confirmation: password,
      status:               "draft"
    )
    puts "Created Dummy Novel: #{title} / #{author_name}"
  end
end

puts 'Done seeding novels.'
