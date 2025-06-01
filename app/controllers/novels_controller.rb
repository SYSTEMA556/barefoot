class NovelsController < ApplicationController
  def index
    # ★ ここで必ず Ransack オブジェクトを用意するのですわ！
    @q = Novel.ransack(params[:q])

    # 検索結果の Relation を受け取ります
    novels = @q.result.includes(:user, :tags)

    # ソートの魔法陣を描く
    case params[:sort]
    when 'comments'
      novels = novels
        .left_joins(:comments)
        .group('novels.id')
        .order('COUNT(comments.id) DESC, novels.created_at DESC')
    when 'views'
      novels = novels.order(view_count: :desc, created_at: :desc)
    else
      novels = novels.order(created_at: :desc)
    end

    # ページネーションの呪文を唱える（Kaminari が導入済みなら）
    novels = novels.page(params[:page]).per(10)

    # そしてビューへお渡し♪
    @novels = novels
  end
end
