class TimeslotsController < ApplicationController
  def create
    require 'time'
    start_time = Time.parse(params['start']) #=> 2010-10-31 00:00:00 -0500
    start_minutes = start_time.strftime('%M')

    end_time = Time.parse(params['end'])
    end_minutes = end_time.strftime('%M')

    redirect_to "/polls/#{params[:id]}/edit?meetings=true"
  end
end
