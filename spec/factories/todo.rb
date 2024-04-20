FactoryBot.define do
  factory :todo do
    title { Faker::Lorem.word }
    description { Faker::Lorem.word }
    due_date { Faker::Date.between(from: '2020-01-01', to: '2024-12-31') }
    completed {[0, 1].sample }
    category { Faker::Lorem.word }
    user_id { Faker::Number.between(from: 1, to: 100) }
  end
end