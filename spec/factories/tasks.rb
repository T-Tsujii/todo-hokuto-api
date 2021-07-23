FactoryBot.define do
  factory :task do
    association :user, factory: :user
    body { Faker::Book.title }
    is_completed { [true, false].sample }
    completed_at { Time.new(2000, 1, 1, 0, 0, 0) }

    trait :complete do
      is_completed { true }
    end

    trait :incomplete do
      is_completed { false }
    end

    trait :invalid do
      body { nil }
    end
  end
end
