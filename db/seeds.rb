# db/seeds.rb

puts 'Seeding novels only...'

if defined?(Faker)
  # Faker があるなら 8,000 件のランダム小説を作成
  80.times do |i|
    title       = Faker::Book.title
    author_name = Faker::Name.name
    body        = Faker::Lorem.paragraph(sentence_count: 980)
    font        = ["こぶり明朝", "游ゴシック", "MS明朝", "ヒラギノ角ゴ", "Shippori Mincho", "Noto Serif JP"].sample
    password    = "novelpass#{i + 1}"

    Novel.create!(
      title:                title,
      author_name:          author_name,
      body:                 body,
      font_choice:          font,
      password:             password,
      password_confirmation: password,
      #status:               ["draft", "published"].sample
    )

    # ログはインターバルを置かないと見づらいので、1000件ごとにだけ出す
    puts "Created #{i+1}/8000 novels..." if (i + 1) % 10 == 0
  end
else
  # Faker がない場合は固定パターンで 8,000 件作成
  80.times do |i|
    idx = i % 6
    title       = "ダミー小説#{i + 1}"
    author_name = "ダミー作者#{i + 1}"
    body        = "これはダミーの本文 #{i + 1} です。"
    font        = ["こぶり明朝", "游ゴシック", "MS明朝", "ヒラギノ角ゴ", "Shippori Mincho", "Noto Serif JP"][idx]
    password    = "dummypass#{i + 1}"

    Novel.create!(
      title:                title,
      author_name:          author_name,
      body:                 body,
      font_choice:          font,
      password:             password,
      password_confirmation: password,
     # status:               (i.even? ? "draft" : "published")
    )

    puts "Created dummy novel #{i+1}/80..." if (i + 1) % 1_000 == 0
  end
end

puts 'Done seeding 8,000 novels.'
