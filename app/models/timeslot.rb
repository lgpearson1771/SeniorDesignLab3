class Timeslot < ActiveRecord::Base
  belongs_to :poll
  has_many :blocks, :dependent => :destroy
end
