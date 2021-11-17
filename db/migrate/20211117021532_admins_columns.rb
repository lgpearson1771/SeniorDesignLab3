class AdminsColumns < ActiveRecord::Migration
  def up
    add_column :admins, :username, :string
    add_column :admins, :password, :string
  end

  def down
    remove_column :admins, :username, :string
    remove_column :admins, :password, :string
  end
end
