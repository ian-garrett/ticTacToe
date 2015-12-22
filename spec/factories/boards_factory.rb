FactoryGirl.define do
  factory :board do
    grid { Array.new(3) { Array.new(3) { '' } } }
  end
end
