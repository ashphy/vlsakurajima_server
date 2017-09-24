FactoryGirl.define do
  factory :message do
    sequence(:message) { |n| "message#{n}" }
    sequence(:tweet_id)
    screen_name 'username'
    sequence(:user_id)
    count 0
  end
end
