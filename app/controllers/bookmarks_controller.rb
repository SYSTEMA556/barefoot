class BookmarksController < ApplicationController
  # ── ログイン必須 ───────────────────────────────────────────
  before_action :authenticate_user!
  before_action :set_search, only: [:index]

  # ── 小説取得は create/destroy 時のみ ─────────────────────────
  before_action :set_novel, only: [:create, :destroy]

  # GET /bookmarks
  def index
    # set_searchで @q を用意しているから、resultを使って絞り込み
    @bookmarked_novels = @q
      .result
      .includes(:user)
      .order('bookmarks.created_at DESC')
      .page(params[:page])
      .per(50)
  end

  # POST /novels/:novel_id/bookmarks
  def create
    current_user.bookmarks.create!(novel: @novel)
    redirect_back(fallback_location: root_path, notice: '🔖 ブックマークしました')
  end

  # DELETE /novels/:novel_id/bookmarks/:id
  def destroy
    current_user.bookmarks.find_by!(novel: @novel).destroy
    redirect_back(fallback_location: root_path, notice: '🔖 ブックマークを解除しました')
  end

  private

  # novels/:novel_id を取得
  def set_novel
    @novel = Novel.find(params[:novel_id])
  end

  # ブックマーク済み小説に対する検索オブジェクトを作成
  def set_search
    @q = current_user.bookmarked_novels.ransack(params[:q])
  end
end
