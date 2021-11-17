class Invitee < ActiveRecord::Base
  has_and_belongs_to_many :invitees
  belongs_to :poll
end
