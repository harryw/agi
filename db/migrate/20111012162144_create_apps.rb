class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.string :name
      t.string :description
      t.string :stage_name
      t.string :deploy_to
      t.string :deploy_user
      t.string :deploy_group
      t.string :multi_tenant
      t.string :uses_bundler
      t.string :alert_emails
      t.string :url
      t.string :git_revision
      t.string :rails_env
      t.string :project_link
      t.string :customer_link
      t.string :database_link
      t.string :chef_account_link
      t.string :cache_cluster_link
      t.string :infrastructure_link
      t.string :newrelic_account_link

      t.timestamps
    end
  end
end
