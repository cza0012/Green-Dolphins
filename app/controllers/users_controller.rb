class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
    @users = User.paginate(:page => params[:page])
  end

  def show
    @user = User.find(params[:id])
    @questions = @user.questions.where(:anonymous => false).order('created_at DESC').paginate(page: params[:page])
  end

end
