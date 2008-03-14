# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def title(page_title)
    content_for(:title) { page_title }
  end
  
  def number_of_days(event)
    length = (event.ends - event.start) / 60 / 60 / 24
    length.round.to_i
  end

  def this_year
    Date.today.year
  end
  
  def this_month
    Date.today.month
  end
  
  def next_month
    Date.today.month.succ 
  end
    
  # This caught me up for a while. What I thought was an inf loop turned out to be a range of
  # every second between every event. Convert to date or the array step contains seconds...
  # TODO: argument: date range
  def array_of_dates
    result ||= []
    Event.find(:all).each do |e|
      ends = Date.parse(e.ends.to_s)
      start = Date.parse(e.start.to_s)
      start.step(ends, 1){ |o| result << o }
    end
    result
  end
  
  def total_events_in_range(timeframe = this_month)
    @start = timeframe.begin
    @ends = timeframe.end
    result[]
    array_of_dates.each do |e|
      if (e >= @start) and (e <= @ends)
        result << e
      end
    end
    result
  end
  
  def event_distance_from_now(event_id)
    from_time = Time.now
    to_time = Event.find_by_id(event_id).start
    distance_of_time_in_words(from_time, to_time, include_seconds = false)
  end
  
  def event_days_possible(month = this_month)
    number_of_rooms * days_in_month(month)
  end
    
  def render_calendar(month, year)
    @array_of_all_dates ||= array_of_dates
    calendar(:year => year, :month => month) do |d|
      if @array_of_all_dates.include?(d)
        [d.mday, {:class => "specialDay"}]
      else 
        [d.mday, {:class => "normalDay"}] 
      end
    end
  end
  
  def render_current_calendar
    render_calendar(this_month, this_year)
  end
  
  def render_next_month_calendar
    render_calendar(next_month, this_year)
  end
  
  def number_of_rooms
    Room.count(:all)
  end
  
  def days_in_month(month = this_month)
    (Date.new(Time.now.year, 12, 31).to_date << (12 - month)).day
  end
  
  def month_range(month)
    1..days_in_month(month)
  end
  
  def occupancy_rate(month = this_month)
    # ( given amount / total amount ) * 100 = percentage
    # ( total_stay_events(month) / event_days_possible(month) ) * 100
  end
  
end
