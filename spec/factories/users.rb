FactoryBot.define do
  factory :user, class: User do
    sequence(:email, 'a') { |n| "factory-#{n}@govpop.com" }
    password BCrypt::Password.create("supersecret")
    reset_token nil
    role nil
    activated_at Time.zone.now

    trait :inactive do
      reset_token BCrypt::Password.create("factory-token")
      activated_at nil
      profile nil
    end

    trait :admin do
      role User::ADMIN
    end

    trait :superadmin do
      role User::ADMIN
    end

    after :build do |user, evaluator|
      user.profile = build :profile, user: user unless user.activated_at.nil? || user.profile.present?
    end
  end
end
