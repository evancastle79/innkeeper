class Event < ActiveRecord::Base
  # TODO: acts_as_versioned

  validates_presence_of :start, :title
  has_and_belongs_to_many :rooms
  has_many :users #, :through => :reservations

 # :calculate_cost
  def has_note?
    !note.blank?
  end
  
  def is_all_day_event?
    !all_day.blank?
  end
  
  def has_duration?
    duration > 0
  end

  def impossible_dates?(desired_start, desired_end)
    flag = false
    if (desired_start >= desired_end) 
      flag = true # logger.debug " First IF fired true..."
    elsif (desired_start < Time.today)
      flag = true # logger.debug " Second IF (start.float < today.float) fired true..."
    else
      flag = false # logger.debug " Neither flag fired true."
    end
    flag
  end
  
  def overlaps_other_event?(desired_start, desired_end, room_id)
    result = 0
    # Only need one, one returns true, which is what we watch for. 3 would be redundant.
    result = Event.find_all_by_start(desired_start..desired_end, :limit => 1)
    result += Event.find_all_by_ends(desired_start..desired_end, :limit => 1)
    result.size >= 1 ? true : false
  end

  def diff_in_mins(start, ends)
    dif_sec = (ends - start).round
    dif_min = dif_sec / 60
    dif_min
  end
  
  def calculate_cost(event_id)
#    # TODO: Calculate real price based on real room prices.
#    # This dummy method charges $0.05 a minute for every event, $72 a day, no matter what.
#    # We only want to do this if the user is a visitor or not logged in.
#    if !@user.has_any_role?("innkeeper", "staff", "admin")
#      event = Event.find_by_id(event_id)
#      cost = (diff_in_mins(event.start,event.ends) * 0.05) # TODO replace
#      cost = (cost * -1)
#    else
#      @user.purse = 0.00
#    end
  end

  def calculate_refund(event_id)
    # TODO: Maybe hold off on this until cost and wallet are more robusto.
  end

end