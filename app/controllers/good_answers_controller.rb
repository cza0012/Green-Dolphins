class GoodAnswersController < ApplicationController
  # GET /good_answers
  # GET /good_answers.json
  def index
    @good_answers = GoodAnswer.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @good_answers }
    end
  end

  # GET /good_answers/1
  # GET /good_answers/1.json
  def show
    @good_answer = GoodAnswer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @good_answer }
    end
  end

  # GET /good_answers/new
  # GET /good_answers/new.json
  def new
    @good_answer = GoodAnswer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @good_answer }
    end
  end

  # GET /good_answers/1/edit
  def edit
    @good_answer = GoodAnswer.find(params[:id])
  end

  # POST /good_answers
  # POST /good_answers.json
  def create
    @comment = Comment.find(params[:good_answer][:comment_id])
    @good_answer = @comment.build_good_answer(params[:good_answer])
    @answer_owner = User.find(@comment.user_id)
    
    respond_to do |format|
      if @good_answer.save
        current_user.add_points(5)
        @answer_owner.add_points(10)
        format.html { redirect_to @good_answer.question, notice: 'Good answer was successfully created.' }
        format.json { render json: @good_answer, status: :created, location: @good_answer }
      else
        format.html { render action: "new" }
        format.json { render json: @good_answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /good_answers/1
  # PUT /good_answers/1.json
  def update
    @good_answer = GoodAnswer.find(params[:id])

    respond_to do |format|
      if @good_answer.update_attributes(params[:good_answer])
        format.html { redirect_to @good_answer, notice: 'Good answer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @good_answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /good_answers/1
  # DELETE /good_answers/1.json
  def destroy
    @good_answer = GoodAnswer.find(params[:id])
    @good_answer.destroy

    respond_to do |format|
      format.html { redirect_to good_answers_url }
      format.json { head :no_content }
    end
  end
end
