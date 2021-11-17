class Renametimeslot < ActiveRecord::Migration
  def change
    rename_table :timeslot, :timeslots
  end
end
