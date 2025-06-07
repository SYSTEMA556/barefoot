# test/controllers/novels_controller_test.rb

require "test_helper"

class NovelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    # fixtures に novel_one を定義しておくと便利ですの。
    @novel = novels(:one) 
    # fixtures/novels.yml に以下のように書いておく例：
    # one:
    #   title: テストフィクスチャ
    #   author_name: フィクスチャ作者
    #   body: fixture テスト本文
    #   font_choice: MS明朝
    #   password_digest: <%= BCrypt::Password.create("fixturepass") %>
  end

  test "正しいパスワードを入力すると編集画面にリダイレクトされること" do
    # フォームにアクセス
    get enter_password_novel_path(@novel)
    assert_response :success

    # 正しいパスワードで submit
    post verify_password_novel_path(@novel), params: { password: "fixturepass" }
    assert_redirected_to edit_novel_path(@novel), "正しいパスワードでも編集画面へリダイレクトされないわ"
  end

  test "誤ったパスワードだと再度入力フォームが表示されること" do
    get enter_password_novel_path(@novel)
    assert_response :success

    post verify_password_novel_path(@novel), params: { password: "wrong" }
    assert_response :success, "間違ったパスワードでもリダイレクトしてしまうわ"
    assert_match "パスワードが違いますわよ", response.body, "エラーメッセージが表示されていないわ"
  end

  test "新規作成時にパスワードなしだと投稿を許可しないこと" do
    assert_no_difference("Novel.count") do
      post novels_path, params: {
        novel: {
          title:       "新規投稿テスト",
          author_name: "テスト太郎",
          body:        "本文テスト",
          font_choice: "ヒラギノ角ゴ"
          # password と password_confirmation をあえて入れない
        }
      }
    end
    assert_response :success, "保存失敗時には new テンプレートを再レンダーしてほしいわ"
    assert_select "div.alert", /パスワードを入力してください/, "エラー表示が期待通りではないわ"
  end

  test "新規作成時にパスワードありで投稿できること" do
    assert_difference("Novel.count", 1) do
      post novels_path, params: {
        novel: {
          title:                "新規投稿テスト２",
          author_name:          "テスト花子",
          body:                 "本文テスト２",
          font_choice:          "ヒラギノ角ゴ",
          password:             "newpass123",
          password_confirmation:"newpass123"
        }
      }
    end
    novel = Novel.last
    assert_redirected_to novel, "投稿後に詳細ページへリダイレクトされないわ"
    follow_redirect!
    assert_match "作品を投稿しましたわ♡", response.body, "flash メッセージが表示されていないわ"
  end
end
