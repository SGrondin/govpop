class Representative < ApplicationRecord

  has_many :questions_sponsors
  has_many :questions, through: :questions_sponsors
  belongs_to :state

  VALID_LEVELS = ['H', 'S', 'ST']
  VALID_PARTIES = ['R', 'D', 'I']

  SHOW_DIMENSIONS = ['id', 'first_name', 'last_name', 'state_id', 'level', 'party']

  validates_presence_of :first_name, :last_name
  validates_inclusion_of :level, in: VALID_LEVELS
  validates_inclusion_of :party, in: VALID_PARTIES

  def for_show
    attributes.slice(*SHOW_DIMENSIONS)
  end

end
