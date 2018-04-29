FactoryBot.define do
  factory :question, class: Question do
    voting_begins_at 1.hour.ago
    voting_ends_at (Time.zone.now + 2.days)
    title "Think Of The Children Act"
    short_text "this is a summary"
    full_text "this is a very very long text"

    after(:build) do |question, evaluator|
      question.creator = (create :user, :admin) unless question.creator.present?
      question.sponsors = Representative.find(80, 81) unless question.sponsors.present?
    end
  end
end
