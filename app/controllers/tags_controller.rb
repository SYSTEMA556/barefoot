# app/controllers/tags_controller.rb
class TagsController < ApplicationController
  def index
    @tags = ActsAsTaggableOn::Tag.most_used(50)
  end

  def show
    @tag = params[:id]
    @novels = Novel.published.tagged_with(@tag).page(params[:page]).per(20)
  end
end
