# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project do
      name "Balance"
      name_tag "balance"
      repository "github.com/mdsol/balance"
      repo_private_key "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    end
end
