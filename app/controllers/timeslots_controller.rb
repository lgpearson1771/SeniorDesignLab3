class TimeslotsController < ApplicationController
  def create
    require 'time'
    start_time = params['start']['start_time(4i)'] + ":" + params['start']["start_time(5i)"]
    print start_time
    start = Time.parse(start_time)
    print start

    redirect_to "/polls/#{params[:id]}/edit?meetings=true"
  end
end
