class QuestionsController < ApplicationController
  before_filter :authenticate_user!
  # GET /questions
  # GET /questions.json
  def index
    @questions = Question.text_search(params[:query]).paginate(page: params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @questions }
    end
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
    @question = Question.find(params[:id])
    @comments = @question.comments.all
    @good_answer = @question.good_answer
    @comment = Comment.new
    @feedback = @question.feedbacks
    @question_owner = @question.question_owner?(current_user)
    @teacher = current_user.has_role?(:ta) || current_user.has_role?(:instructor)
    @admin = current_user.has_role?(:admin)
    @taLimitTime = @question.created_at + 12.hours
    @instructureLimitTime = @question.created_at + 2.days
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
    @number_of_experts = @experts.count
    @number_of_experts.times do
      @question.notifications.build
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
    @number_of_experts = @experts.count
    @number_of_experts.times do
      @question.notifications.build
    end
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = current_user.questions.build(params[:question])
    
    respond_to do |format|
      if @question.save
        current_user.add_points(5)
        current_user.add_expert_role
        format.html { redirect_to @question, notice: 'Question was successfully created.' }
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

    respond_to do |format|
      if @question.update_attributes(params[:question])
        format.html { redirect_to @question, notice: 'Question was successfully updated.' }
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
    @question.destroy

    respond_to do |format|
      format.html { redirect_to questions_url }
      format.json { head :no_content }
    end
  end
end
