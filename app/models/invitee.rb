class Invitee < ActiveRecord::Base
  has_and_belongs_to_many :blocks
  belongs_to :poll
end
