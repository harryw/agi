class MergeIqWithMedistranoPirToDeployments < ActiveRecord::Migration
  def change
    add_column :deployments, :merge_iq_with_medistrano_pir, :boolean, :default => false
  end
end
