FactoryBot.define do
  factory :user do
    email { 'test@example.com' }
    password { 'password' }
    two_factor_authentication { false }
  end
end