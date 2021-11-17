class Block < ActiveRecord::Base
  belongs_to :timeslots
  has_and_belongs_to_many :invitees
end
