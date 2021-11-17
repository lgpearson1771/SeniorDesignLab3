class Timeslot < ActiveRecord::Base
  belongs_to :polls
  has_many :blocks
end
