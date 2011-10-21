# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :deployment do
      user_link "MyString"
      git_repo "MyString"
      git_commit "MyString"
      description "MyText"
      send_email false
      task "MyString"
      do_migrations false
      migration_command "MyString"
      result_log "MyText"
      app_id 1
      started_at "2011-10-17 16:27:03"
      completed_at "2011-10-17 16:27:03"
      deployment_timestamp "2011-10-17 16:27:03"
    end
end

