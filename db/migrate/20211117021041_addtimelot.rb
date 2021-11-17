class Addblocks < ActiveRecord::Migration
  def up
    create_table :timeslot
  end

  def down
    drop_table :timeslot
  end
end
