# app/controllers/comments_controller.rb

class CommentsController < ApplicationController
  before_action :set_novel
  before_action :set_comment, only: [:verify_password, :confirm_delete]

  def create
    @comment = @novel.comments.build(comment_params)
    @comment.user = current_user if current_user

    if @comment.save
      redirect_to novel_path(@novel), notice: 'コメントを投稿したわ♡'
    else
    flash.now[:alert] = @comment.errors.full_messages.join(", ")
      render 'novels/show'
    end  # ← ここで create を閉じる end

  end  # ← もともと抜けていたメソッドの end を追加

  def verify_password
    @novel   = Novel.find(params[:novel_id])
    @comment = @novel.comments.find(params[:id])
  end

  def confirm_delete
    if @comment.authenticate(params[:password])
      @comment.destroy
      redirect_to novel_path(@comment.novel), notice: 'コメントを削除しました。'
    else
      flash.now[:alert] = 'パスワードが正しくありません。'
      render :verify_password
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    unless comment.user == current_user || current_user&.admin?
      redirect_back fallback_location: root_path, alert: "権限がありませんわ"
      return
    end
    comment.destroy
    redirect_back fallback_location: root_path, notice: "コメントを削除いたしました"
  end

  private

 def comment_params
  params.require(:comment).permit(
    :body,
    :guest_password,
    :guest_password_confirmation
  )
end

  def set_novel
    @novel = Novel.find(params[:novel_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end
end  # ← クラス定義の end（既にあるか再確認を）
