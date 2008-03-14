class Room < ActiveRecord::Base
  
#    The Rooms are manipulated in two ways: 
#      The Innkeeper changes their properties
#      An event triggers a change to a rooms properties, such as "occupied" or "clean"
#    
#    The "base_price" is the price that all price modifiers change. For example,
#    a room has a base price of 100 and a price modifier of 25. When the mod is
#    triggered, the price will calculate to 125. If the base price changes before then
#    to 150, the modifier will change the price to 175 when triggered. In this way we
#    keep prices modular and the modifiers are dynamic.
#    
#    A room has a "teaser", a one-line description that is intended to get the viewers
#    attention. It also has a "description", a longer version of the teaser. 
#    
#    TODO:
#      * Room images
#      * Maximum occupancy
#      * Minimum stay length
#      

validates_presence_of   :name, :base_price, :location
validates_uniqueness_of :name, :location

has_many                :events
  
  # room.clean set to false, takes a room as a parameter.
  def set_room_is_dirty(room)
    room.clean = 0
  end
  
  # room.clean set to true, takes a room as a parameter.
  def set_room_is_clean(room)
    room.clean = 1
  end

  # This goes a step beyond set_room_is_dirty - it sends an email requesting a cleaning.
  def require_cleaning(room)
    set_room_is_dirty(room)
    # TODO: email/IM cleaning staff a vacated/cleaning request
  end

  # A visitor can request a cleaning in the middle of their stay.
  def vistitor_requested_cleaning(room, person)
    # TODO: Send a email/IM to the staff requesting an /immediate/ cleaning (and who requested it, possibly Innkeeper).
  end

  # room.occupied set to false, takes a room as a parameter. Sets cleaning required.
  def vacate_room(room)
    room.occupied = 0
  end

  # room.occupied set to true, takes a room as a parameter.
  def occupy_room(room)
    room.occupied = 1
  end

  def notify_staff(event, room, person)
    # TODO: email: #{person.full_name} has #{event.title} in #{room.location}.
  end

  # Runs any time a check-in occurs. Sets dirty, notifies staff, etc
  def checking_in_procedure(person, room, event)
    occupy_room(room)
    set_room_is_dirty(room)
    # notify_staff(event, room, person)
  end

end