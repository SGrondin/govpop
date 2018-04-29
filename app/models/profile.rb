class Profile < ApplicationRecord

  belongs_to :user
  belongs_to :state

  acts_as_paranoid

  UPDATE_DIMENSIONS = [:state_id, :gender, :age, :ethnicity, :education]
  SHOW_DIMENSIONS = UPDATE_DIMENSIONS.map(&:to_s)

  VALID_GENDERS = ['M', 'F', 'O']
  VALID_AGES = ['0-18', '19-35', '36-50', '51-65', '66+']
  VALID_ETHNICITIES = ['W', 'AA', 'H', 'A', 'O']
  VALID_EDUCATIONS = ['L', 'HS', 'B', 'G']

  validates_inclusion_of :gender, in: VALID_GENDERS, allow_blank: true
  validates_inclusion_of :age, in: VALID_AGES, allow_blank: true
  validates_inclusion_of :ethnicity, in: VALID_ETHNICITIES, allow_blank: true
  validates_inclusion_of :education, in: VALID_EDUCATIONS, allow_blank: true

  def for_show
    attributes.slice(*SHOW_DIMENSIONS)
  end

end
