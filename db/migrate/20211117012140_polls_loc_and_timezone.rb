class PollsLocAndTimezone < ActiveRecord::Migration
  class PollsTitleDesc < ActiveRecord::Migration
    def change
      add_column :polls, :timezone, :string
      add_column :polls, :location, :string
    end
  end
end
