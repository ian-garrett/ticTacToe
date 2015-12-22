FactoryGirl.define do
  factory :user do
    username { FFaker::Name.name }
    password 'foobarbaz'
  end

  factory :player_1, class: User do
    username { FFaker::Name.name }
    password 'foobarbaz'
  end
end
