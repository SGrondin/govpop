class UsersVote < ApplicationRecord
  belongs_to :question
  belongs_to :user

  VALID_VOTES = ['Y', 'N']

  validates_inclusion_of :vote, in: VALID_VOTES
  validate :validate_question_is_open, on: :create

  private

  def validate_question_is_open
    raise ValidationError.new("Question is not open for voting") unless question.open?
  end

end
