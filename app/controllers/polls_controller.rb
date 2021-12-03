class PollsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def poll_params
    params.require(:poll).permit(:title, :description, :location, :votes_per_user, :votes_per_timeslot, :timezone, :deadline)
  end

  def index
    if params[:commit] == 'Login'
      val = authenticate(params[:username], params[:password])
      if ['invalid username', 'invalid password/username'].include?(val)
        redirect_to '/'
        return
      end
    end
    if params[:commit] == 'Publish'
      @poll = Poll.find(params[:publish])
      @poll.published = true
      @poll.save
      Poll.send_emails(params[:publish])
    end
    if params[:commit] == 'Close'
      @poll = Poll.find(params[:close])
      @poll.published = false
      @poll.save
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
    session[:user_id] = nil
  end

  def authenticate(username, password)
    session[:user_id] = nil
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
    if poll_info["deadline_enable"] == "1"
      deadline = DateTime.new(poll_info['deadline(1i)'].to_i,
                              poll_info['deadline(2i)'].to_i,
                              poll_info['deadline(3i)'].to_i,
                              poll_info['deadline(4i)'].to_i,
                              poll_info['deadline(5i)'].to_i,
                              poll_info['deadline(6i)'].to_i)
    end

    poll = Poll.create({title: poll_info['title'],
                        description: poll_info['description'],
                        location: poll_info['location'],
                        votes_per_user: poll_info['user_votes'],
                        votes_per_timeslot: poll_info['votes_per_timeslot'],
                        timezone: poll_info['timezone'],
                        admin_id: session[:admin_id],
                        deadline: deadline # poll_info['deadline']
                       })

    unless poll.valid?
      flash[:warning] = ''
      poll.errors.keys.each do |key|
        flash[:warning] = flash[:warning] + "#{key} #{ poll.errors[key].first}, "
      end
      flash[:warning] = flash[:warning][0...-2]
      return redirect_to '/polls/new'
    end
    redirect_to "/polls/#{poll.id}/edit?meetings=true"
  end

  def edit
    @timeslots = Timeslot.where(poll_id: params[:id])
    @poll = Poll.find(params[:id])
  end

  def update
    poll_info = params[:poll]

    if poll_info["deadline_enable"] == "1"
      deadline = DateTime.new(poll_info['deadline(1i)'].to_i,
                              poll_info['deadline(2i)'].to_i,
                              poll_info['deadline(3i)'].to_i,
                              poll_info['deadline(4i)'].to_i,
                              poll_info['deadline(5i)'].to_i,
                              poll_info['deadline(6i)'].to_i)
    end


    @poll = Poll.update(params[:poll_id], {title: poll_info['title'],
                                           description: poll_info['description'],
                                           location: poll_info['location'],
                                           votes_per_user: poll_info['votes_per_user'],
                                           votes_per_timeslot: poll_info['votes_per_timeslot'],
                                           timezone: poll_info['timezone'],
                                           deadline: deadline # poll_info['deadline']
    })

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

  def show
    @show_all = (params[:show_all] == 'false' or params[:show_all].nil?)
    @poll = Poll.find(params[:id])
    @block_data = []
    @poll.timeslots.each do |timeslot|
      timeslot.blocks.each do |block|
        block.invitees.each do |invitee|
          @block_data.append({time: "#{block.timeslot.day.strftime("%m/%d/%Y")} #{block.start} - #{block.end}", invitee: invitee.email})
        end
        if block.invitees.length == 0 and @show_all
          @block_data.append({time: "#{block.timeslot.day.strftime("%m/%d/%Y")} #{block.start} - #{block.end}", invitee: ''})
        end
      end
    end
    @invitee_info = []
    @poll.invitees.each do |invitee|
      @invitee_info.append({votes_left: "#{invitee.votes_left}/#{invitee.poll.votes_per_user}", email: invitee.email, id: invitee.id})
    end
  end

  def remind
    remind_list = []
    Poll.find(params[:id]).invitees.each do |invitee|
      if invitee.votes_left > 0
        remind_list.append(invitee)
      end
    end
    if remind_list.length > 0
      Poll.remind_partial(remind_list)
    end

    render :json => {}
  end

  def publish
    poll = Poll.find(params[:id])
    if poll.timeslots.length == 0
      return render :json => {has_timeslots: false}
    end
    poll.published = params[:publish] == 'true'
    poll.save
    begin
      if params[:publish] == 'true'
        Poll.send_emails(params[:id])
      end
    rescue ArgumentError => e
      # Ignored
    end
    render :json => {has_timeslots: true, id: poll.id}
  end
end
