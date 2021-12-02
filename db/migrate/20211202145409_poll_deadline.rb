class PollDeadline < ActiveRecord::Migration
  def change
    add_column :polls, :deadline, :datetime
  end
end
