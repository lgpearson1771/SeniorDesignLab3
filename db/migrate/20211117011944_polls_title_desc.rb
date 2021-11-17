class PollsTitleDesc < ActiveRecord::Migration
  def change
    add_column :polls, :title, :string
    add_column :polls, :description, :string
  end
end
