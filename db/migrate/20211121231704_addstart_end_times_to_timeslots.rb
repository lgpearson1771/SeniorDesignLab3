class AddstartEndTimesToTimeslots < ActiveRecord::Migration
  def change
    add_column :timeslots, :start, :date
    add_column :timeslots, :end, :date
    remove_column :timeslots, :day, :date
  end
end
