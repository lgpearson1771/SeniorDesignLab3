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
                    password: 'PASSWORD_GOES_HERE',
                    authentication: :login,
                    domain: 'localhost.localdomain'
                  },
                  subject: 'sending email test',
                  body: 'did this work? :))'
                })
    end
  end

end
