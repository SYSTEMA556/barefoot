class CommentsController < ApplicationController
  before_action :set_novel

  def create
    @comment = @novel.comments.build(comment_params)
    @comment.user = current_user if current_user

    if @comment.save
      redirect_to novel_path(@novel), notice: 'コメントを投稿したわ♡'
    else
      flash.now[:alert] = @comment.errors.full_messages.join(", ")
      render 'novels/show'
    end
  end

  def destroy
    @comment = @novel.comments.find(params[:id])
    if @comment.user == current_user
      @comment.destroy
      redirect_to novel_path(@novel), notice: 'コメントを削除したわ♡'
    else
      redirect_to novel_path(@novel), alert: '他人のコメントは消せないのよ！'
    end
  end

  private

 def set_novel
    @novel = Novel.find(params[:novel_id])
  end

  def comment_params
    permitted = [:body]
    # ゲスト時はパスワード関連も許可
    permitted += [:guest_password, :guest_password_confirmation] unless current_user
    params.require(:comment).permit(permitted)
  end
end