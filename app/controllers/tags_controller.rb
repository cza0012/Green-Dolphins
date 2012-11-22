class TagsController < ApplicationController
  def questions
    if params[:tag]
      @questions = Question.tagged_with(params[:tag])
    else
      @questions = Question.all
    end
  end
  def users
    if params[:tag]
      @users = User.tagged_with(params[:tag])
    else
      @users = User.all
    end
  end
end
