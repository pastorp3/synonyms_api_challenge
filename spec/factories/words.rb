FactoryBot.define do
  factory :word do
    str { 'example' }
  end

  factory :synonym do
    association :word, factory: :word
    synonym { 'similar' }
  end
end