class QuestionsSponsor < ApplicationRecord
  belongs_to :question
  belongs_to :representative
end
