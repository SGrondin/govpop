class QuestionsController < ApplicationController

  def index
    render_success 200, { questions: Question.order(id: :desc).limit(5).map(&:for_index) }
  end

  def show
    render_success 200, Question.find(params.require(:id)).for_show
  end

  def create
    authorize! :create, Question
    question = Question.new(creator: current_user)
    question.assign_attributes(params.permit(*Question::UPDATE_DIMENSIONS))
    question.sponsors = Representative.find params.require(:sponsors)
    question.save!
    render_success 200, question.reload.for_show
  end

  def update
    authorize! :update, Question
    question = Question.find params.require(:id)
    question.assign_attributes(params.permit(*Question::UPDATE_DIMENSIONS))
    question.sponsors = Representative.find params.require(:sponsors) if params.has_key?(:sponsors)
    question.save!
    render_success 200, question.for_show
  end

  def vote
    question = Question.find params.require(:id)
    raise ValidationError.new("Already voted") if question.user_has_voted? current_user

    question.user_vote!(current_user, params.require(:vote))

    render_success 200, question.for_show
  end

end
