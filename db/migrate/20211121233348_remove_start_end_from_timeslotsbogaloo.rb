class RemoveStartEndFromTimeslotsbogaloo < ActiveRecord::Migration
  def change
      remove_column :timeslots, :start, :date
      remove_column :timeslots, :end, :date
  end
end
