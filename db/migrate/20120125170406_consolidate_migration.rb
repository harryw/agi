class ConsolidateMigration < ActiveRecord::Migration
  def change
    create_table "apps", :force => true do |t|
      t.string   "name"
      t.string   "description"
      t.string   "stage_name"
      t.string   "deploy_to"
      t.string   "deploy_user"
      t.string   "deploy_group"
      t.string   "alert_emails"
      t.string   "url"
      t.string   "git_revision"
      t.string   "rails_env"
      t.string   "cache_cluster_link"
      t.string   "infrastructure_link"
      t.string   "newrelic_account_link"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "customer_id"
      t.integer  "project_id"
      t.integer  "chef_account_id"
      t.boolean  "multi_tenant"
      t.boolean  "uses_bundler",          :default => true
      t.string   "platform"
      t.string   "database_id"
      t.string   "git_branch"
    end

    create_table "chef_accounts", :force => true do |t|
      t.string   "name"
      t.string   "formal_name"
      t.text     "validator_key"
      t.text     "client_key"
      t.text     "databag_key"
      t.string   "api_url"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "client_name"
    end

    create_table "customers", :force => true do |t|
      t.string   "name_tag"
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "customizations", :force => true do |t|
      t.string   "name"
      t.string   "location"
      t.string   "value"
      t.boolean  "prompt_on_deploy"
      t.integer  "customizable_id"
      t.string   "customizable_type"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "databases", :force => true do |t|
      t.string   "name"
      t.string   "db_name"
      t.string   "username"
      t.string   "password"
      t.text     "client_cert"
      t.string   "db_type"
      t.string   "instance_class"
      t.integer  "instance_storage"
      t.boolean  "multi_az"
      t.string   "availability_zone"
      t.string   "engine_version"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "state"
      t.boolean  "started"
      t.string   "hostname"
    end

    create_table "deployments", :force => true do |t|
      t.string   "user_link"
      t.string   "git_repo"
      t.string   "git_commit"
      t.boolean  "send_email"
      t.string   "task"
      t.boolean  "run_migrations"
      t.string   "migration_command"
      t.integer  "app_id"
      t.datetime "started_at"
      t.datetime "completed_at"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.datetime "deployment_timestamp"
      t.text     "deployed_data"
      t.boolean  "force_deploy",         :default => false
      t.string   "final_result"
      t.string   "opscode_result"
      t.text     "opscode_log"
      t.string   "description"
      t.integer  "user_id"
    end

    create_table "projects", :force => true do |t|
      t.string   "name_tag"
      t.string   "name"
      t.string   "homepage"
      t.text     "description"
      t.string   "repository"
      t.text     "repo_private_key"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "users", :force => true do |t|
      t.string   "email",                                 :default => "", :null => false
      t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
      t.string   "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.integer  "sign_in_count",                         :default => 0
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip"
      t.string   "last_sign_in_ip"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "users", ["email"], :name => "index_users_on_email", :unique => true
    add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  end
end
