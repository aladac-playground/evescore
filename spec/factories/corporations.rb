# frozen_string_literal: true

FactoryBot.define do
  factory :corporation do
    trait :corp1 do
      id 1_000_021
      name 'Zero-G Research Firm'
      ticker 'ZGRF'
    end
    trait :corp2 do
      id 1_000_035
      name 'Caldari Navy'
      ticker 'CN'
    end
  end
end
