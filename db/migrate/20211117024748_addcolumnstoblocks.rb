class Addcolumnstoblocks < ActiveRecord::Migration
  def change
    add_reference :blocks, :timeslots, index: true
    add_column :blocks, :start, :string
    add_column :blocks, :end, :string
  end
end
