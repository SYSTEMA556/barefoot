class BookmarksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_novel, only: [:create, :destroy]

  def index
    @bookmarked_novels = current_user.bookmarked_novels.page(params[:page])
  end

  def create
    current_user.bookmarks.create!(novel: @novel)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    current_user.bookmarks.find_by!(novel: @novel).destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def set_novel
    @novel = Novel.find(params[:novel_id])
  end
end
