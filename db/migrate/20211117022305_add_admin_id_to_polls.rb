class AddAdminIdToPolls < ActiveRecord::Migration
  def up
    change_table :polls do |t|
      t.references 'admin'
    end
  end

  def down
    remove_column :polls, :admin_id, :integer
  end
end
