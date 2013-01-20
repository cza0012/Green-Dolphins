class UserFeedbackRepliesController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /user_feedback_replies
  # GET /user_feedback_replies.json
  def index
    @user_feedback_replies = UserFeedbackReply.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_feedback_replies }
    end
  end

  # GET /user_feedback_replies/1
  # GET /user_feedback_replies/1.json
  def show
    @user_feedback_reply = UserFeedbackReply.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_feedback_reply }
    end
  end

  # GET /user_feedback_replies/new
  # GET /user_feedback_replies/new.json
  def new
    @user_feedback_reply = UserFeedbackReply.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_feedback_reply }
    end
  end

  # GET /user_feedback_replies/1/edit
  def edit
    @user_feedback_reply = UserFeedbackReply.find(params[:id])
  end

  # POST /user_feedback_replies
  # POST /user_feedback_replies.json
  def create
    @user_feedback_reply = UserFeedbackReply.new(params[:user_feedback_reply])

    respond_to do |format|
      if @user_feedback_reply.save
        format.html { redirect_to @user_feedback_reply, notice: 'User feedback reply was successfully created.' }
        format.json { render json: @user_feedback_reply, status: :created, location: @user_feedback_reply }
      else
        format.html { render action: "new" }
        format.json { render json: @user_feedback_reply.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_feedback_replies/1
  # PUT /user_feedback_replies/1.json
  def update
    @user_feedback_reply = UserFeedbackReply.find(params[:id])

    respond_to do |format|
      if @user_feedback_reply.update_attributes(params[:user_feedback_reply])
        format.html { redirect_to @user_feedback_reply, notice: 'User feedback reply was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_feedback_reply.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_feedback_replies/1
  # DELETE /user_feedback_replies/1.json
  def destroy
    @user_feedback_reply = UserFeedbackReply.find(params[:id])
    @user_feedback_reply.destroy

    respond_to do |format|
      format.html { redirect_to user_feedback_replies_url }
      format.json { head :no_content }
    end
  end
end
