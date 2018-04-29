class RepresentativesVote < ApplicationRecord
  belongs_to :question
  belongs_to :representative

  VALID_VOTES = ['Y', 'N', 'A']

  validates_inclusion_of :vote, in: VALID_VOTES

end
