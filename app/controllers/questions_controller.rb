class QuestionsController < ApplicationController
  before_filter :authenticate_user!
  # GET /questions
  # GET /questions.json
  def index
    @questions = Question.text_search(params[:query]).paginate(page: params[:page])
    @tags = [{ id: 14,name: "sorting"}]
    if !@questions.blank?
      @questions.first.create_activity key: 'questions.read', owner: current_user, params: { query: params[:query] }
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @questions }
    end
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
    @question = Question.find(params[:id])
    @comments = @question.comments.where('deleted_comment = false').order("created_at ASC")
    @good_answer = @question.good_answer
    @comment = Comment.new
    @reply = Reply.new
    # No code feedback
    # @feedback = @question.feedbacks
    @question_owner = @question.question_owner?(current_user)
    @teacher = current_user.has_role?(:ta) || current_user.has_role?(:instructor)
    @admin = current_user.has_role?(:admin)
    @taLimitTime = @question.created_at + 3.hours
    @InstructorLimitTime = @question.created_at + 6.hours
    @delayTAAnswer = current_user.has_role?(:ta) && !@taLimitTime.past?() && !@question.fast_answer
    @delayInstructorAnswer = current_user.has_role?(:instructor) && !@InstructorLimitTime.past?() && !@question.fast_answer
    @question.create_activity key: 'question.read', owner: current_user
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @question }
    end
  end

  # GET /questions/new
  # GET /questions/new.json
  def new
    @question = Question.new
    @experts = User.with_role(:expert)
    # @number_of_experts = @experts.count

    2.times do
      @question.notifications.build()
    end
    
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @question }
    end
  end

  # GET /questions/1/edit
  def edit
    @question = Question.find(params[:id])
    @experts = User.with_role(:expert)
    # @number_of_experts = @experts.count
    
    2.times do
      @question.notifications.build()
    end
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = current_user.questions.build(params[:question])
    user_points = current_user.points
    
    respond_to do |format|
      if @question.save
        @question.teacher_notification
        if @question.fast_answer
            current_user.deduct_points(10)
        else
            current_user.add_points(5)
        end
        current_user.add_expert_role
        format.html { redirect_to @question, notice: "Question was successfully created." + User.points_bill(user_points, current_user.points)}
        format.json { render json: @question, status: :created, location: @question }
      else
        format.html { render action: "new" }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /questions/1
  # PUT /questions/1.json
  def update
    @question = Question.find(params[:id])
    previous_fast_answer = @question.fast_answer
    user_points = current_user.points
    
    respond_to do |format|
      if @question.update_attributes(params[:question])
        if @question.fast_answer && !previous_fast_answer
            current_user.deduct_points(5)
        end
        format.html { redirect_to @question, notice: "Question was successfully updated."  + User.points_bill(user_points, current_user.points)}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question = Question.find(params[:id])
    @question.archive_question
    @question.user.deduct_points(5)
    # @question.destroy

    respond_to do |format|
      format.html { redirect_to questions_url }
      format.json { head :no_content }
    end
  end
end
