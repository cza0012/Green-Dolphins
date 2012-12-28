class TagsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @tags = Question.tag_counts.order(:name)
    respond_to do |format|
      format.html
      format.json { render json: @tags.where("LOWER(name) like ?", "%#{params[:q]}%") }
    end
  end
  
  def questions
    if params[:tag]
      @questions = Question.paginate(:page => params[:page]).tagged_with(params[:tag])
      if !@questions.blank?
        @questions.first.create_activity key: 'tags.questions.see', owner: current_user, params: { tag: params[:tag] }
      end
    else
      @questions = Question.all
    end
  end
  
  def users
    if params[:tag]
      @users = User.paginate(:page => params[:page]).tagged_with(params[:tag])
      if !@users.blank?
        @users.first.create_activity key: 'tags.users.see', owner: current_user, params: { tag: params[:tag] }
      end
    else
      @users = User.all
    end
  end
end
