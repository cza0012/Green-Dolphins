class TagsController < ApplicationController
  def questions
    if params[:tag]
      @questions = Question.tagged_with(params[:tag])
    else
      @questions = Question.all
    end
  end
end
