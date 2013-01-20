class UserFeedbacksController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /user_feedbacks
  # GET /user_feedbacks.json
  def index
    @user_feedbacks = UserFeedback.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_feedbacks }
    end
  end

  # GET /user_feedbacks/1
  # GET /user_feedbacks/1.json
  def show
    @user_feedback = UserFeedback.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_feedback }
    end
  end

  # GET /user_feedbacks/new
  # GET /user_feedbacks/new.json
  def new
    @user_feedback = UserFeedback.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_feedback }
    end
  end

  # GET /user_feedbacks/1/edit
  def edit
    @user_feedback = UserFeedback.find(params[:id])
  end

  # POST /user_feedbacks
  # POST /user_feedbacks.json
  def create
    @user_feedback = UserFeedback.new(params[:user_feedback])

    respond_to do |format|
      if @user_feedback.save
        format.html { redirect_to @user_feedback, notice: 'User feedback was successfully created.' }
        format.json { render json: @user_feedback, status: :created, location: @user_feedback }
      else
        format.html { render action: "new" }
        format.json { render json: @user_feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_feedbacks/1
  # PUT /user_feedbacks/1.json
  def update
    @user_feedback = UserFeedback.find(params[:id])

    respond_to do |format|
      if @user_feedback.update_attributes(params[:user_feedback])
        format.html { redirect_to @user_feedback, notice: 'User feedback was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_feedbacks/1
  # DELETE /user_feedbacks/1.json
  def destroy
    @user_feedback = UserFeedback.find(params[:id])
    @user_feedback.destroy

    respond_to do |format|
      format.html { redirect_to user_feedbacks_url }
      format.json { head :no_content }
    end
  end
end
