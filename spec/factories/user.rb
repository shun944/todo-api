FactoryBot.define do
  factory :user do
    username { Faker::Lorem.word }
    email { "#{Faker::Lorem.word}@exaple.com" }
  end
end