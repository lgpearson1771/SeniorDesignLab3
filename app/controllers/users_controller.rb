class UsersController < ApplicationController
  def poll
    @id = params[:id]
    invitee = Invitee.find(@id)
    @timeslots = invitee.poll.timeslots
    @poll_name = "test poll #{@id}"
    render 'poll_signup'
  end

  def add_poll
    @id = params[:id]
    #add block registration to database with block id and userid(@id)
    # block id = params[:poll][time]
    @poll_name = "test poll #{@id}"
    render 'poll_signup'
  end
end
