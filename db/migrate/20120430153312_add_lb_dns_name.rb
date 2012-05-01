class AddLbDnsName < ActiveRecord::Migration
  def change
    add_column :apps, :lb_dns ,:string
    add_column :apps, :dynect_cname_name, :string
    add_column :deployments, :dynect_cname_log, :string
  end
end
