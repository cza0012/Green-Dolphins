class CommentsController < ApplicationController
  before_filter :authenticate_user!
  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.json
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.json
  def create
    # It fixs to the first line and the second question.
    @comment = current_user.comments.build(params[:comment])
    user_points = current_user.points
    
    respond_to do |format|
      if @comment.save
        if @comment.hidden
          @comment.delay_comment(current_user)
        else
          @comment.notifications.create({ user_id: @comment.question.user_id, read: false })
        end
        current_user.add_points(10)
        current_user.add_expert_role
        format.html { redirect_to @comment.question, notice: "Comment was successfully created." + User.points_bill(user_points, current_user.points) }
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { render action: "new" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @comment.question, notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    @question = @comment.question
    @comment.archive_comment
    # @comment.destroy

    respond_to do |format|
      format.html { redirect_to @question }
      format.json { head :no_content }
    end
  end
end
