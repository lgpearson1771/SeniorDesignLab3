class RemoveStartEndFromTimeslots < ActiveRecord::Migration
  def change
    remove_column :timeslots, :start, :string
    remove_column :timeslots, :end, :string
  end
end
