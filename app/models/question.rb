class Question < ApplicationRecord

  belongs_to :creator, class_name: "User"

  has_many :questions_sponsors
  has_many :sponsors, through: :questions_sponsors, source: :representative

  has_many :representatives_votes

  acts_as_paranoid

  UPDATE_DIMENSIONS = [:voting_begins_at, :voting_ends_at, :title, :short_text, :full_text, :level]
  INDEX_DIMENSIONS = ['id', 'voting_begins_at', 'voting_ends_at', 'title', 'level', 'sponsors']
  SHOW_DIMENSIONS = ['id'] + UPDATE_DIMENSIONS.map(&:to_s)

  validates_presence_of UPDATE_DIMENSIONS
  validates_presence_of :sponsors
  validate :validate_sponsors_level
  validate :validate_voting_dates
  validates_inclusion_of :level, in: Representative::VALID_LEVELS

  before_validation :apply_level

  def for_index
    attributes.slice(*INDEX_DIMENSIONS)
    .merge!({
      sponsors: sponsors.map(&:for_show)
    })
  end

  def for_show
    attributes.slice(*SHOW_DIMENSIONS)
    .merge!({
      sponsors: sponsors.map(&:for_show)
    })
  end

  def open?
    voting_begins_at <= Time.zone.now && voting_ends_at >= Time.zone.now
  end

  def user_has_voted? user
    UsersVote.exists?("#{id}-#{user.id}")
  end

  def user_vote! user, vote
    UsersVote.create!({
      id: "#{id}-#{user.id}",
      question: self,
      user: user,
      vote: vote
    })
  end

  private

  def apply_level
    self.level = sponsors.first.level
  end

  def validate_sponsors_level
    dedup = sponsors.map(&:level).uniq
    if dedup.size > 1
      errors.add(:sponsors, 'must all be at the same level of government')
    end
    if dedup.first != level
      errors.add(:level, 'must be at the same level of government as the sponsors')
    end
  end

  def validate_voting_dates
    if voting_begins_at.present? && voting_ends_at.present? && voting_begins_at > voting_ends_at
      errors.add(:voting_begins_at, 'must be greater than voting_ends_at')
    end
  end

end
