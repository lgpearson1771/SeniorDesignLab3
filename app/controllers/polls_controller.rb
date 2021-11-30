class PollsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def poll_params
    params.require(:poll).permit(:title, :description, :location, :votes_per_user, :votes_per_timeslot, :timezone)
  end

  def index
    if session[:admin_id].nil?
      val = authenticate(params[:username], params[:password])
      if ['invalid username', 'invalid password/username'].include?(val)
        redirect_to '/'
        return
      end
    end
    if params[:commit] == 'Publish'
      print "This is where we will send emails to users associated to poll #{params[:publish]}\n"
    end
    if params[:commit] == 'Delete'
      poll = Poll.where(id: params[:delete])[0]
      poll&.destroy
    end
    @admin = Admin.find(session[:admin_id])
    @polls = Poll.where({ admin_id: session[:admin_id] })
    if !params[:search_title].nil? && params[:search_title].length.positive?
      @polls = Poll.where({ admin_id: session[:admin_id], title: params[:search_title] })
    end
  end

  def login
    # renders the admin login page no functionality needed
  end

  def authenticate(username, password)
    user_info = Admin.where({ username: username })[0]
    if user_info.nil? || user_info.blank?
      flash[:warning] = 'This username does not exist'
      'invalid username'
    elsif password == user_info.password
      session[:admin_id] = user_info.id
    else
      flash[:warning] = 'Incorrect login credentials'
      'invalid password/username'
    end
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
      flash[:warning] = ''
      poll.errors.keys.each do |key|
        flash[:warning] = flash[:warning] + "#{key} #{ poll.errors[key].first}; "
      end
      return redirect_to '/polls/new'
    end
    redirect_to "/polls/#{poll.id}/edit?meetings=true"
  end

  def edit
    @timeslots = Timeslot.where(poll_id: params[:id])
    @poll = Poll.find(params[:id])
  end

  def update
    @poll = Poll.update(params[:poll_id], poll_params)

    unless @poll.valid?
      flash[:warning] = ''
      @poll.errors.keys.each do |key|
        flash[:warning] = flash[:warning] + "#{key} #{ @poll.errors[key].first}; "
      end
      return redirect_to "/polls/#{@poll.id}/edit?properties=true"
    end
    redirect_to "/polls/#{@poll.id}/edit?meetings=true"
  end

  def invitees
    @poll = Poll.find(params[:id])
    render "/polls/invitees"
  end

end
