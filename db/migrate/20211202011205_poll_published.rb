class PollPublished < ActiveRecord::Migration
  def change
    add_column :polls, :published, :boolean
  end
end
