class PollsController < ApplicationController
  def index
    authenticate(params[:username], params[:password])
  end

  def login
    # renders the admin login page no functionality needed
  end

  def authenticate(username, password)
    # verify a login
    # third-part auth???
  end

  def new
  end

  def create
    poll_info = params[:poll]
    poll = Poll.create({title: poll_info['title'],
                        description: poll_info['description'],
                        location: poll_info['location'],
                        votes_per_user: poll_info['user_votes'],
                        votes_per_timeslot: poll_info['votes_per_timeslot'],
                        timezone: poll_info['timezone']
                       })

    unless poll.valid?
      flash[:warning] = ""
      poll.errors.keys.each do |key|
        flash[:warning] = flash[:warning] + "#{key} #{ poll.errors[key].first}; "
      end
      return redirect_to "/polls/new"
    end
  end

  def edit

  end

end
