class Poll < ActiveRecord::Base
  belongs_to :admin

  validates :title, presence: true
  validates_length_of :title, :minimum => 4

  validates :description, presence: true
  #validates :location, presence: true

  validates :votes_per_user, presence: true
  validates :votes_per_user, numericality: { greater_than: 0, only_integer: true}
  validates :votes_per_timeslot, presence: true
  validates :votes_per_timeslot, numericality: { greater_than: 0, only_integer: true }
  validates :timezone, presence: true
  validates :timezone, inclusion: { in: %w(EDT CDT MDT PDT ADT HST),
                                    message: "%{value} is not a valid timezone" }

  def add_times

  end
end
