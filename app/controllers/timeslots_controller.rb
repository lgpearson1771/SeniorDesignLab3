class TimeslotsController < ApplicationController
  def create

    start_minute = params['start']['start_time(5i)'].to_i
    end_minute = params['end']['end_time(5i)'].to_i
    start_hour = params['start']['start_time(4i)'].to_i
    end_hour = params['end']['end_time(4i)'].to_i

    if params["AM_PM_start"]['select'] == "PM"
      timeslot_start_time = (start_hour + 12).to_s + ":" + start_minute.to_s
      start = start_hour.to_i + 12
    else
      timeslot_start_time = params['start']['start_time(4i)'] + ":" + params['start']['start_time(5i)']
      start = start_hour
      if start_hour == 12
        start = start - 12
        timeslot_start_time = (params['start']['start_time(4i)'].to_i - 12).to_s + ":" + start_minute.to_s
      end
    end

    if params["AM_PM_end"]['select'] == "PM"
      timeslot_end_time = (end_hour + 12).to_s + ":" + params['end']['end_time(5i)']
      end_time =  end_hour + 12
    else
      timeslot_end_time = params['end']['end_time(4i)'] + ":" + params['end']['end_time(5i)']
      end_time =  end_hour
    end

    total_minutes = (end_time - start) * 60 - start_minute + end_minute
    print "\n\n total:#{total_minutes}  start hr: #{start}start min:#{start_minute} end hr: #{end_time} end min:#{end_minute}"
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
      flash[:warning] = 'no' #todo fix
      redirect_to "/polls/#{params[:poll_id]}/edit?meetings=true"
      return
    end

    day = Date.strptime(params[:date], '%Y-%m-%d')
    timeslot = Timeslot.create(day: day, end: timeslot_end_time, start: timeslot_start_time, poll_id: params[:poll_id])

    (0..(total_minutes - interval)).step(interval) do |number|
      start_first = number / 60 + start
      start_second = (number + start_minute) % 60
      end_first = (number + interval) / 60 + start
      end_second = ((number + interval) + start_minute) % 60
      start_first = start_first - 12 if start_first > 12
      end_first = end_first - 12 if end_first > 12
      start_second = start_second.to_s + "0" if start_second.to_s.length == 1
      end_second = end_second.to_s + "0" if end_second.to_s.length == 1

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
