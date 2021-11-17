class Addcolumnstotimeslot < ActiveRecord::Migration
  def change
    add_reference :timeslot, :polls, index: true
    add_column :timeslot, :start, :string
    add_column :timeslot, :end, :string
    add_column :timeslot, :day, :date
  end
end
