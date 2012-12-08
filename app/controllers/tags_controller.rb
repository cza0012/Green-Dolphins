class TagsController < ApplicationController
  before_filter :authenticate_user!
  
  def questions
    if params[:tag]
      @questions = Question.paginate(:page => params[:page]).tagged_with(params[:tag])
    else
      @questions = Question.all
    end
  end
  def users
    if params[:tag]
      @users = User.paginate(:page => params[:page]).tagged_with(params[:tag])
    else
      @users = User.all
    end
  end
end
