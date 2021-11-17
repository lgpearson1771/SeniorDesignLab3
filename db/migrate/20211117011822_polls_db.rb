class PollsDb < ActiveRecord::Migration
  def up
    create_table :polls
  end

  def down
    drop_table :polls
  end
end
