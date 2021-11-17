class PollsController < ApplicationController

  def poll_params
    params.require(:poll).permit(:title, :description, :location, :votes_per_user, :votes_per_timeslot, :timezone)
  end

  def index
    authenticate(params[:username], params[:password])
    @polls = Poll.where({ admin_id: session[:admin_id] })
    @admin = Admin.find(session[:admin_id])
  end

  def login
    # renders the admin login page no functionality needed
  end

  def authenticate(username, password)
    # verify a login
    # third-part auth???
    session[:admin_id]= Admin.where({ username: username })[0].id
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
    redirect_to "/polls/#{poll.id}/edit?meetings=true"
  end

  def edit
    @poll = Poll.find(params[:id])
  end

  def update
    @poll = Poll.update(params[:poll_id], poll_params)

    unless @poll.valid?
      flash[:warning] = ""
      @poll.errors.keys.each do |key|
        flash[:warning] = flash[:warning] + "#{key} #{ @poll.errors[key].first}; "
      end
      return redirect_to "/polls/#{@poll.id}/edit?properties=true"
    end
    redirect_to "/polls/#{@poll.id}/edit?meetings=true"
  end

end
