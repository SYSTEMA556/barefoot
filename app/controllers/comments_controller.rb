class CommentsController < ApplicationController
  before_action :set_novel
  before_action :set_comment, only: [:confirm_delete, :verify_password]

  # コメント投稿
  def create
    @comment = @novel.comments.build(comment_params)
    if @comment.save
      redirect_to novel_path(@novel), notice: 'コメントを投稿したわ♡'
    else
      flash.now[:alert] = @comment.errors.full_messages.join(", ")
      render 'novels/show'
    end
  end

  # 削除確認画面を表示
  def confirm_delete
    # ビューでパスワード入力フォームを表示するだけよ♡
  end

  # パスワード認証後に削除
 def verify_password
    # ネストされた場合もトップレベルの場合も拾う
    pw = params.dig(:comment, :guest_password) || params[:guest_password]

    if @comment.authenticate_guest_password(pw)
      @comment.destroy
      redirect_to novel_path(@novel), notice: 'コメントを削除しましたわ♡'
    else
      redirect_to novel_path(@novel), alert: 'パスワードが違いますわ…'
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
    @comment = @novel.comments.find(params[:id])
  end
end
