class TimeslotsController < ApplicationController
  def create

    if params["AM_PM_start"]['select'] == "PM"
      timeslot_start_time = (params['start']['start_time(4i)'].to_i + 12).to_s + ":" + params['start']['start_time(5i)']
      start = params['start']['start_time(4i)'].to_i + 12
      if params['start']['start_time(4i)'].to_i == 12
        start = start - 12
        timeslot_start_time = (params['start']['start_time(4i)'].to_i).to_s + ":" + params['start']['start_time(5i)']
      end
    else
      timeslot_start_time = params['start']['start_time(4i)'] + ":" + params['start']['start_time(5i)']
      start = params['start']['start_time(4i)'].to_i
    end

    if params["AM_PM_end"]['select'] == "PM"
      timeslot_end_time = (params['end']['end_time(4i)'].to_i + 12).to_s + ":" + params['end']['end_time(5i)']
      end_time =  params['end']['end_time(4i)'].to_i + 12
      if params['end']['end_time(4i)'].to_i == 12
        start = start - 12
        timeslot_start_time = (params['end']['end_time(4i)'].to_i).to_s + ":" + params['end']['end_time(5i)']
      end
    else
      timeslot_end_time = params['end']['end_time(4i)'] + ":" + params['end']['end_time(5i)']
      end_time =  params['end']['end_time(4i)'].to_i
    end

    end_time_fifteen_multiple = params['end']['end_time(5i)'].to_i/ 15
    start_time_fifteen_multiple = params['start']['start_time(5i)'].to_i
    time_interval = ((end_time - start) * 60 - start_time_fifteen_multiple + end_time_fifteen_multiple)

    if params['time_blocks']['select'] == 'blocks'
      interval = (time_interval / params[:timeslot][:blocks].to_i)
    else
      interval = params['times']['times'].to_i
    end
    if interval % 15 != 0
      flash[:warning] = 'no'
      redirect_to "/polls/#{params[:poll_id]}/edit?meetings=true"
      return
    end

    day = Date.strptime(params[:date], '%Y-%m-%d')
    timeslot = Timeslot.create(day: day, end: timeslot_end_time, start: timeslot_start_time, poll_id: params[:poll_id])

    (0..(time_interval - interval)).step(interval) do |number|
      start_first = number / 60 + start
      start_second = (number + params['start']['start_time(5i)'].to_i) % 60
      end_first = (number + interval) / 60 + start
      end_second = ((number + interval) + params['start']['start_time(5i)'].to_i) % 60
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
