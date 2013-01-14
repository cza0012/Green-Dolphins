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
    @numberOfAdmins = User.with_role(:admin).count
    @numberOfInstructor = User.with_role(:instructor).count
    @numberOfTA = User.with_role(:ta).count
    @numberOfStudent = @users.length - (@numberOfAdmins+@numberOfInstructor+@numberOfTA)
    if !@users.blank?
      @users.first.create_activity key: 'leaderboard.see', owner: current_user
    end
  end
  
  def performance
    @answers = Comment.all
    @exist_questions = Question.where("deleted_question = false").count
    @number_answers = current_user.comments.count
    @number_questions = current_user.questions.count
    @number_usefuls = current_user.usefuls.count
    @number_replies = current_user.replies.count

    if !@answers.blank?
      current_user.create_activity key: 'performance.see', owner: current_user
    end
  end

end
