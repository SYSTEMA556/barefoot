# app/controllers/comments_controller.rb

class CommentsController < ApplicationController
  before_action :set_novel
  before_action :set_comment, only: [:verify_password, :confirm_delete]

  def create
    @comment = @novel.comments.build(comment_params)
    if @comment.save
      redirect_to novel_path(@novel), notice: 'コメントを投稿したわ♡'
    else
      flash.now[:alert] = @comment.errors.full_messages.join(", ")
      render 'novels/show'
    end
  end

  # パスワード入力画面を表示
  def verify_password
    # 特に処理は不要。対応するビューを表示するだけ
  end

  # パスワード認証後に削除
# app/controllers/comments_controller.rb
def confirm_delete
  if @comment.authenticate_guest_password(params[:comment][:guest_password])
    @comment.destroy
    redirect_to novel_path(@novel), notice: "コメントを削除しましたわ♡"
  else
    flash.now[:alert] = "パスワードが違いますわ…"
    render :verify_password
  end
end


  private

  def comment_params
    params.require(:comment).permit(:body, :guest_password, :guest_password_confirmation)
  end

  def set_novel
    @novel = Novel.find(params[:novel_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end
end
