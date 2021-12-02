class Invitee < ActiveRecord::Base
  has_and_belongs_to_many :blocks
  belongs_to :poll
  @@time_interval = nil

  def self.time_interval
    @@time_interval
  end

  def self.time_interval=(val)
    @@time_interval = val
  end
end
