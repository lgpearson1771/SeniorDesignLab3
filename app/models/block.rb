class Block < ActiveRecord::Base
  belongs_to :timeslot
  has_and_belongs_to_many :invitees
  before_destroy { invitees.clear }
end
