# test/models/novel_test.rb

require "test_helper"

class NovelTest < ActiveSupport::TestCase
  # setupブロックで共通の属性を定義しますわ
  setup do
    @valid_attributes = {
      title:        "テスト小説",
      author_name:  "テスト作者",
      body:         "これはテスト用の本文です。",
      font_choice:  "MS明朝",
      password:              "secret123",
      password_confirmation: "secret123"
    }
    @no_password_attrs = @valid_attributes.except(:password, :password_confirmation)
  end

  test "パスワードが存在するとき、有効な Novel が保存できること" do
    novel = Novel.new(@valid_attributes)
    assert novel.valid?, "パスワードを含む正しい属性で novel.valid? が false になっているわ"
    assert novel.save, "パスワード付きの novel が保存できなかったわ"
    # 保存後、password_digest が存在するか確認
    assert_not_nil novel.password_digest, "保存後に password_digest がセットされていないわ"
    # authenticate メソッドで認証を試みる
    assert novel.authenticate("secret123"), "正しいパスワードでも authenticate が false を返すわ"
    assert_not novel.authenticate("wrongpass"), "間違ったパスワードで authenticate が true を返しているわ"
  end

  test "パスワードが未設定だとバリデーションに引っかかること" do
    novel = Novel.new(@no_password_attrs)
    assert_not novel.valid?, "パスワードなしで novel.valid? が true になっているわ"
    assert_includes novel.errors[:password], "を入力してください", "password 欄のエラーメッセージが期待通りではないわ"
  end

  test "password_confirmation が一致しないと保存できないこと" do
    attrs = @valid_attributes.merge(password_confirmation: "different")
    novel = Novel.new(attrs)
    assert_not novel.valid?, "パスワード確認と一致しないのに valid? が true になっているわ"
    assert_includes novel.errors[:password_confirmation], "とパスワードの入力が一致しません", "password_confirmation のエラーが期待通りではないわ"
  end
end
