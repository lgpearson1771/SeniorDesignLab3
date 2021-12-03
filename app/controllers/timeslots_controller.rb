class TimeslotsController < ApplicationController
  def create
    if params["AM_PM_start"]['select'] == "PM" && params["AM_PM_end"]['select'] == "AM"
      flash[:warning] = 'Start time must be before end time and cannot go past midnight.'
      return redirect_to "/polls/#{params[:poll_id]}/edit?meetings=true"
    end

      start_minute = params['start']['start_time(5i)'].to_i
    end_minute = params['end']['end_time(5i)'].to_i
    start_hour = params['start']['start_time(4i)'].to_i
    end_hour = params['end']['end_time(4i)'].to_i

    start_mins_string = params['start']['start_time(5i)']
    end_mins_string = params['end']['end_time(5i)']
    start_mins_string = "0" + start_mins_string if start_mins_string.length == 1
    end_mins_string = "0" + start_mins_string if start_mins_string.length == 1

    start_hour_string = params['start']['start_time(4i)']
    end_hour_string = params['end']['end_time(4i)']
    start_hour_string = "0" + start_hour_string if start_hour_string.length == 1
    end_hour_string = "0" + end_hour_string if end_hour_string.length == 1

    if params["AM_PM_start"]['select'] == "PM"
      timeslot_start_time = (start_hour + 12).to_s + ":" + start_mins_string
      start = start_hour.to_i + 12
    else
      timeslot_start_time = start_hour_string + ":" + start_mins_string
      start = start_hour
      if start_hour == 12
        start = start - 12
        timeslot_start_time = "0" + (start_hour - 12).to_s + ":" + start_mins_string # 00:xx
      end
    end

    if params["AM_PM_end"]['select'] == "PM"
      timeslot_end_time = (end_hour + 12).to_s + ":" + end_mins_string
      end_time =  end_hour + 12
    else
      timeslot_end_time = end_hour_string + ":" + end_mins_string
      end_time =  end_hour
    end
    total_minutes = (end_time - start) * 60 - start_minute + end_minute

    if params['time_blocks']['select'] == 'blocks'
      interval = (total_minutes / params[:timeslot][:blocks].to_i)
    else
      interval = params['times']['times'].to_i
    end

    if end_time * 60 + end_minute < start * 60 + start_minute
      flash[:warning] = 'end time cannot be before start time'
      redirect_to "/polls/#{params[:poll_id]}/edit?meetings=true"
      return
    end

    if interval % 5 != 0
      flash[:warning] = 'block sizes must be in five minute intervals'
      redirect_to "/polls/#{params[:poll_id]}/edit?meetings=true"
      return
    end

    if interval == 0
      flash[:warning] = 'Timeslot must have time between start and end'
      return redirect_to "/polls/#{params[:poll_id]}/edit?meetings=true"
    end

    day = Date.strptime(params[:date], '%Y-%m-%d')
    timeslot = Timeslot.create(day: day, end: timeslot_end_time, start: timeslot_start_time, poll_id: params[:poll_id])

    (0..(total_minutes - interval)).step(interval) do |number|
      start_first = (number + start_minute) / 60 + start
      start_second = (number + start_minute) % 60
      end_first = (number + interval + start_minute) / 60 + start
      end_second = (number + interval+ start_minute) % 60


      start_first = "0" + start_first.to_s if start_first.to_s.length == 1
      end_first = "0" + end_first.to_s if end_first.to_s.length == 1
      start_second = "0" + start_second.to_s if start_second.to_s.length == 1
      end_second = "0" + end_second.to_s if end_second.to_s.length == 1
      print "\n\n#{start_first}:#{start_second} - #{end_first}:#{end_second}\n\n"

      Block.create(start: "#{start_first}:#{start_second}", end: "#{end_first}:#{end_second}", timeslot_id: timeslot.id)
    end

    redirect_to "/polls/#{params[:poll_id]}/edit?meetings=true"
  end

  def destroy
    @timeslot = Timeslot.find(params[:id])
    poll_id = @timeslot[:poll_id]
    @timeslot.blocks.each do |block|
      block.destroy
    end
    @timeslot.destroy
    redirect_to "/polls/#{poll_id}/edit?meetings=true"
  end
end
