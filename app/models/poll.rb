class Poll < ActiveRecord::Base
  belongs_to :admin
  has_many :timeslots
  has_many :invitees

  validates :title, presence: true
  validates_length_of :title, minimum: 4

  validates :description, presence: true
  #validates :location, presence: true

  validates :votes_per_user, presence: true
  validates :votes_per_user, numericality: { greater_than: 0, only_integer: true }
  validates :votes_per_timeslot, presence: true
  validates :votes_per_timeslot, numericality: { greater_than: 0, only_integer: true }
  validates :timezone, presence: true
  validates :timezone, inclusion: { in: %w(EDT CDT MDT PDT ADT HST),
                                    message: '%{value} is not a valid timezone' }

  def add_times

  end

  def self.send_emails(poll_id)
    poll = Poll.find(poll_id)
    invitees = Invitee.where({ poll_id: poll_id })
    invitees.each do |invitee|
      Pony.mail({
                  to: invitee.email,
                  via: :smtp,
                  via_options: {
                    address: 'smtp.gmail.com',
                    port: '587',
                    enable_starttls_auto: true,
                    user_name: 'TheOhmbresSDL3@gmail.com',
                    password: ENV['email_password'],
                    authentication: :login,
                    domain: 'localhost.localdomain'
                  },
                  subject: "Invitation to signup for #{poll.title}",
                  body: "You have been invited to sign-up for a timeslot(s).
                         Sign-up here: 'http://localhost:3000/users/login/#{poll_id}'"
                })
    end
  end

  def self.remind_partial(invitees)
    poll = invitees[0].poll
    invitees.each do |invitee|
      Pony.mail({
                  to: invitee.email,
                  via: :smtp,
                  via_options: {
                    address: 'smtp.gmail.com',
                    port: '587',
                    enable_starttls_auto: true,
                    user_name: 'TheOhmbresSDL3@gmail.com',
                    password: ENV['email_password'],
                    authentication: :login,
                    domain: 'localhost.localdomain'
                  },
                  subject: "Reminder to vote in poll #{poll.title}",
                  body: "You have #{invitee.votes_left} votes out of #{poll.votes_per_user} left in the poll!"
      })
    end
  end
end
