class CreateDeployments < ActiveRecord::Migration
  def change
    create_table :deployments do |t|
      t.string :user_link
      t.string :git_repo
      t.string :git_commit
      t.text :description
      t.boolean :send_email
      t.string :task
      t.boolean :do_migrations
      t.string :migration_command
      t.text :result_log
      t.integer :app_id
      t.datetime :started_at
      t.datetime :completed_at

      t.timestamps
    end
  end
end
