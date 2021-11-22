class Addfieldstotimetamp < ActiveRecord::Migration
  def change
    add_column :timeslots, :start, :string
    add_column :timeslots, :end, :string
    add_column :timeslots, :day, :date
  end
end
