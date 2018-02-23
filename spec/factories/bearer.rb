FactoryBot.define do
  factory :bearer do
    name "Me"
  end

  factory :bearer_2, class: Bearer do
    name "Me 2"
  end

  factory :bearer_3, class: Bearer do
    name "Me 3"
  end
end
