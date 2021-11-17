class PollsVotes < ActiveRecord::Migration
  def change
    add_column :polls, :votes_per_user, :integer
    add_column :polls, :votes_per_timeslot, :integer
  end
end
