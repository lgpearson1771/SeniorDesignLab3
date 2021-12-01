class UsersController < ApplicationController
  before_action :verify_user, except: [:login, :check_login]

  def poll
    #   <div class="item1" style="grid-column: column-pos / span column-width; grid-row: row-pos / span row-length;">Content</div>
    @id = params[:id]
    @poll_name = "test poll #{@id}"
    @user = Invitee.find(session[:user_id])
    require 'time'
    require 'date'



    @calendar = {}
    day_count = 1

    @poll = Poll.find(@id)
    @timeslots = @poll.timeslots.all
    # @timeslots.sort_by { |obj| obj.start }
    @timeslots = @timeslots.sort{ |a,b| (a.day == b.day) ? a.start <=> b.start : a.day <=> b.day }
    @min_time= 60*23 + 45
    @max_time= 0

    @timeslots.each do |time|
      unless @calendar.key?(time.day)
        @calendar[time.day] = {
          min_time: 60*23 + 45,
          max_time: 0
        }
      end
      if get_time(time.start) < @calendar[time.day][:min_time]
        @calendar[time.day][:min_time] = get_time(time.start)
      end
      if get_time(time.end) > @calendar[time.day][:max_time]
        @calendar[time.day][:max_time] = get_time(time.end)
      end

      if get_time(time.start) < @min_time
        @min_time = get_time(time.start)
      end
      if get_time(time.end) > @max_time
        @max_time = get_time(time.end)
      end
    end

    @max_time = @max_time + 15


    prev_time = nil
    prev_day = nil


    @timeslots.each do |time|
      blocks = time.blocks
      blocks.each do |block|
        # min_time = @calendar[time.day][:min_time]
        reserved = false
        if block.invitees.find_by_id(@user.id)
          id = block.id
          reserved = true
          booked = false
        elsif block.invitees.length < @poll.votes_per_timeslot
          id = block.id
          booked = false
        else
          id = nil
          booked = true
        end

        if ! @calendar[time.day].key?(:times)

          day_count = day_count + 1
          start_time = get_time(block.start)
          end_time = get_time(block.end)
          #
          # if !prev_day.nil? && prev_time < @max_time
          #   @calendar[prev_day][:times] << {column: day_count - 1,
          #                                   row: (prev_time - @min_time) / 15 + 1 + 1,
          #                                   duration: (@max_time - prev_time) / 15,
          #                                   id: nil}
          # end
          if !prev_day.nil? && prev_time < @max_time
            (prev_time..( @max_time-15)).step(15) do |t|
              @calendar[prev_day][:times] << {column: day_count - 1,
                                              row: (t-@min_time)/15 + 1 + 1,
                                              duration: 1,
                                              id: nil}
            end

          end

          @calendar[time.day][:times] = []
          # unless start_time - @min_time == 0
          #   @calendar[time.day][:times] << {column: day_count,
          #                                   row: 1 + 1,
          #                                   duration: (start_time - @min_time) / 15,
          #                                   id: nil}
          # end
          unless start_time - @min_time == 0
            (@min_time..(start_time-15)).step(15) do |t|
              @calendar[time.day][:times] << {column: day_count,
                                              row: (t-@min_time)/15 + 1 + 1,
                                              duration: 1,
                                              id: nil}
            end

          end


          @calendar[time.day][:times] << {column: day_count,
                                          row: (start_time - @min_time) / 15 + 1 + 1,
                                          duration: (end_time - start_time) / 15,
                                          id: id,
                                          booked: booked,
                                          reserved: reserved}
          prev_time = end_time
          prev_day = time.day
        else
          start_time = get_time(block.start)
          end_time = get_time(block.end)

          if prev_time != start_time
            (prev_time..(start_time-15)).step(15) do |t|
              @calendar[time.day][:times] << {column: day_count,
                                              row: (t-@min_time)/15 + 1 + 1,
                                              duration: 1,
                                              id: nil}
            end

          end
          # if prev_time != start_time
          #   @calendar[time.day][:times] << {column: day_count,
          #                                   row: (prev_time - @min_time) / 15 + 1 + 1,
          #                                   duration: (start_time - prev_time) / 15,
          #                                   id: nil}
          # end


          @calendar[time.day][:times] << {column: day_count,
                                          row: (start_time - @min_time) / 15 + 1 + 1,
                                          duration: (end_time - start_time) / 15,
                                          id: id,
                                          booked: booked,
                                          reserved: reserved}
          prev_time = end_time
          prev_day = time.day
        end
      end


    end

    if !prev_day.nil? && prev_time < @max_time
      (prev_time..(@max_time-15)).step(15) do |t|
        @calendar[prev_day][:times] << {column: day_count,
                                        row: (t-@min_time)/15 + 1 + 1,
                                        duration: 1,
                                        id: nil}
      end

    end
    # if !prev_day.nil? && prev_time < @max_time
    #   @calendar[prev_day][:times] << {column: day_count ,
    #                                   row: (prev_time - @min_time) / 15 + 1 + 1,
    #                                   duration: (@max_time - prev_time) / 15,
    #                                   id: nil}
    # end
    print(@calendar)


    print("HERE")

    render 'poll_signup'
  end

  def show
    @block = Block.find(params[:block_id])
    @timeslot = Timeslot.find(@block.timeslot_id)
    @poll = Poll.find(@timeslot.poll_id)
  end

  def cancel
    @block = Block.find(params[:block_id])
    @timeslot = Timeslot.find(@block.timeslot_id)
    @poll = Poll.find(@timeslot.poll_id)
    @user = Invitee.find(session[:user_id])
    @user.blocks.delete(@block)
    @user.votes_left = @user.votes_left + 1
    @user.save
    flash[:notice] = "Reservation canceled."
    redirect_to "/poll_signup/#{@poll.id}"
  end

  def signup
    @block = Block.find(params[:block_id])
    @timeslot = Timeslot.find(@block.timeslot_id)
    @poll = Poll.find(@timeslot.poll_id)

  end

  def signup_confirmation
    @block = Block.find(params[:block_id])
    print(params)
    @timeslot = @block.timeslot
    @poll = @timeslot.poll
    @user = Invitee.find(session[:user_id])

    unless @user.votes_left > 0
      flash[:warning] = "You do not have any votes left!"
      return redirect_to "/poll_signup/#{@poll.id}"
    end

    @user.blocks << @block
    @user.votes_left = @user.votes_left - 1
    @user.save
    #add block registration to database with block id and userid(@id)

    #add block registration to database with block id and userid(@id)    # get timeslot
    # get poll
    # get user
    # Check if any more blocks are available for the timeslot
    # Check if user is allowed to sign up for any more blocks
    #   Done by
    #     Counting # of blocks associated to user (Through block invitees) (Even the same email is a different "user" for different polls)
    #     Compare with number allowed in poll information
    # If so create a new block in that timeslot
    # associate user with that block (Through block invitees)
    # redirect to thanks
    # If not available
    #   redirect back to the select page
    #   display flash message
    redirect_to thanks_path
  end

  def login
    unless Poll.find_by_id(params[:id])
      return redirect_to users_error_path
    end
    @title = Poll.find_by_id(params[:id]).title

  end

  def check_login
    unless Poll.find_by_id(params[:id])
      return redirect_to users_error_path
    end
    @poll = Poll.find_by_id(params[:id])

    unless @poll.invitees.where(email: params[:email]).length > 0
      flash[:warning] = "Invalid email!"
      return redirect_to "/users/login/#{@poll.id}"
    end
    @user = Invitee.where(email: params[:email])[0]
    session[:user_id] = @user.id
    # return redirect_to users_error_path

    redirect_to "/poll_signup/#{@poll.id}"
  end

  def logout
    session[:user_id] = nil
    redirect_to "/users/login/#{params[:id]}"
  end

  def add_poll
    @id = params[:id]
    # add block registration to database with block id and userid(@id)
    # block id = params[:poll][time]
    @poll_name = "test poll #{@id}"
    render 'poll_signup'
  end

  def get_time(time)
    time = time.scan(/(\d\d):(\d\d)/)[0].map{|string| string.to_i}
    time[0] * 60 + time[1]
  end

  def self.print_time(time)
    hour = time/60
    min = time % 60
    if hour < 10
      hour = "0#{hour}"
    end
    if min < 10
      min = "0#{min}"
    end
    "#{hour}:#{min}"
  end

  def thanks
    @user = Invitee.find(session[:user_id])
    @poll = @user.poll
  end

  def verify_user
    session[:admin_id] = nil
    @poll = Poll.find_by_id(params[:id])
    @user = Invitee.find(session[:user_id])
    unless params[:id].nil? || @poll.invitees.find_by_id(@user.id)
      return redirect_to users_error_path
    end
  end
end
