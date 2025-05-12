# app/controllers/tags_controller.rb
class TagsController < ApplicationController
  def index
    @tags = Tag.all.order(:name)
  end

  def show
    @tag    = Tag.find(params[:id])
    @novels = @tag.novels.order(created_at: :desc).page(params[:page])
  end
end
