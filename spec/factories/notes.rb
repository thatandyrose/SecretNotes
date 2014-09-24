# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :note do
    encrypted_title "MyString"
    encrypted_body "MyString"
    password_hash "MyString"
    password_salt "MyString"
  end
end
