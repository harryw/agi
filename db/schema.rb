# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111025154924) do

  create_table "apps", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "stage_name"
    t.string   "deploy_to"
    t.string   "deploy_user"
    t.string   "deploy_group"
    t.string   "multi_tenant"
    t.string   "uses_bundler"
    t.string   "alert_emails"
    t.string   "url"
    t.string   "git_revision"
    t.string   "rails_env"
    t.string   "database_link"
    t.string   "chef_account_link"
    t.string   "cache_cluster_link"
    t.string   "infrastructure_link"
    t.string   "newrelic_account_link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "customer_id"
    t.integer  "project_id"
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
  end

  create_table "customers", :force => true do |t|
    t.string   "name"
    t.string   "formal_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deployments", :force => true do |t|
    t.string   "user_link"
    t.string   "git_repo"
    t.string   "git_commit"
    t.text     "description"
    t.boolean  "send_email"
    t.string   "task"
    t.boolean  "do_migrations"
    t.string   "migration_command"
    t.text     "result_log"
    t.integer  "app_id"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deployment_timestamp"
    t.text     "json_data"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "formal_name"
    t.string   "homepage"
    t.text     "description"
    t.string   "respository"
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
