# app/controllers/bookmarks_controller.rb

class BookmarksController < ApplicationController
  # ── ログイン必須 ───────────────────────────────────────────
  before_action :authenticate_user!
   before_action :require_login 
  # ── 小説取得は create/destroy 時のみ ─────────────────────────
  before_action :set_novel, only: [:create, :destroy]
  # （index は novel 単体じゃなくユーザー全体の一覧なので不要）

  # GET /bookmarks
  def index
    @bookmarked_novels = current_user
                          .bookmarked_novels
                          .includes(:user)
                          .order('bookmarks.created_at DESC')
                          .page(params[:page])
                          .per(20)
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
end
