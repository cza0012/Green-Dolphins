require 'will_paginate/array'

class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
    @users = User.paginate(:page => params[:page])
    if !@users.blank?
      @users.first.create_activity key: 'users.see', owner: current_user
    end
  end

  def show
    @user = User.find(params[:id])
    @question = @user.questions.where(:anonymous => false).order('created_at DESC')
    @comment = @user.comments.where(:anonymous => false).order('created_at DESC')
    @user_feed = @user.user_feed(@question,@comment).paginate(page: params[:page], per_page: 10)
    @user.create_activity key: 'user.see', owner: current_user
  end
  
  def leaderboard
    @users = User.order('points DESC')
    if !@users.blank?
      @users.first.create_activity key: 'leaderboard.see', owner: current_user
    end
  end

end
