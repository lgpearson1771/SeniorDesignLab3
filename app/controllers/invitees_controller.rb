class InviteesController < ApplicationController
  def create
    email = params[:invitee][:email]
    poll = Poll.find(params[:poll])
    email_regex = /^([A-Za-z0-9!#$%&'*+\-\/=?^_`{|}~]+)(\.[A-Za-z0-9!#$%&'*+\-\/=?^_`{|}~]+)*@[a-zA-z0-9]+(\.[a-zA-z0-9]+)*$/
    unless email_regex.match(email)
      flash[:warning] = 'Not a valid email address'
      return redirect_to "/polls/#{poll.id}/invitees"
    end
    Invitee.create({votes_left: poll.votes_per_user, email: email, poll_id: poll.id})
    redirect_to "/polls/#{poll.id}/invitees"
  end

  def destroy
    invitee = Invitee.find(params[:id])
    poll = invitee.poll
    invitee.blocks.each do |block|
      invitee.delete(block)
    end

    redirect_to "/polls/#{poll.id}/invitees"
  end
end
