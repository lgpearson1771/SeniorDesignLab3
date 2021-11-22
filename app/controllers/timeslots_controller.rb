class TimeslotsController < ApplicationController
  def create
    require 'time'
    x = Timeslot.all
    print x[0].attributes

    redirect_to "/polls/#{params[:id]}/edit?meetings=true"
  end
end
