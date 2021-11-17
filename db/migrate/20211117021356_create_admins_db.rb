class CreateAdminsDb < ActiveRecord::Migration
  def up
    create_table :admins
  end

  def down
    drop_table :admins
  end
end
