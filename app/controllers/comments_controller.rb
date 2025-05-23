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
  comment = Comment.find(params[:id])
  unless comment.user == current_user || current_user&.admin?
    redirect_back fallback_location: root_path, alert: "権限がありませんわ"
    return
  end
  comment.destroy
  redirect_back fallback_location: root_path, notice: "コメントを削除いたしました"
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