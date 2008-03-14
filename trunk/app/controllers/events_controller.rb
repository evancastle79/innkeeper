class EventsController < ApplicationController
  # Example Usage:
  # 
  #    require_role "contractor"
  #    require_role "admin", :only => :destroy # don't allow contractors to destroy
  #    require_role "admin", :only => :update, :unless => "current_user.authorized_for_listing?(params[:id]) "
  #
  # Valid options
  #
  #  * :only - Only require the role for the given actions
  #  * :except - Require the role for everything but 
  #  * :if - a Proc or a string to evaluate.  If it evaluates to true, the role is required.
  #  * :unless - The inverse of :if

  require_role "innkeeper", :only => :index
  
  # There should be no functions in here: move functions to the model,
  # This should be step-by-step handoffs for processing transactions
  
  # steps (new users new events):
  # -- At each step, save the step we're on on the event
  # EXAMPLE:
#  class GuestBookController < ActionController::Base
#    def index
#      @entries = Entry.find(:all)
#    end
#
#    def sign
#      Entry.create(params[:entry])
#      redirect_to :action => "index"
#    end
#  end
#  
  # ensure the event is possible
#  def event_is_possible
#    #...
#    redirect_to :action => 'check_login_or_create'
#  end
#  # inspect the user & create a user where none exsists
#  def check_login_or_create
#    #...
#  end
  # calculate the cost of the event(s) in question
  # save the event & save the cost to the users wallet
  # create the key for the door
  # save the event to the db
  # notify the appropriate authorities of event
  # send out the key and the various info

  # steps (exsisting users / editing events)
  # make sure the change is possible
  # inspect the user
  # calc the change 
  # save the change to the purse and event
  # inform the nessisary parties of the changes
  
  # steps (authorized edit)
  # same as above, only save the changes in price to
  # the correct users purse.
  
  # GET /events
  # GET /events.xml
  def index
    @events = Event.find(:all, :page => {:size => 7, :current => params[:page]})
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.xml
  def create
    # This is the meat of the program
    @event = Event.new(params[:event])
    respond_to do |format|
      if @event.impossible_dates?(@event.start, @event.ends)
        flash[:error] = 'The reservation could not be made: Make sure the start date comes <b>before</b> the end date and that it is in the <b>future</b>.'
        redirect_to(new_event_path)
        break
      end      

      if @event.overlaps_other_event?(@event.start, @event.ends, @event.room_id)
        flash[:error] = 'The reservation could not be made: it conflicted with another reservation already in our system.'
        redirect_to(new_event_path)
        break
      end
      
      @user = User.find_by_id(@event.user_id)
#      new_purse_total = @user.purse + calculate_cost(@event.id)
#      @user.purse = new_purse_total
      
      if @user.save
        flash[:notice] = 'Account updated'
      else
        flash.now[:error] = 'Your account could not be updated.'
        break
      end
      
      if @event.save    
      # TODO: ReservationConfirmationMailer.deliver_user_reservation_confirmation(@current_user, @event)
      
      # TODO: this is where most of the important linear herding goes for event creation
        flash[:notice] = 'Event was successfully created.'
        format.html { redirect_to(@event) }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        flash[:notice] = 'Event NOT created, there was some error. Please try again.'
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    # params[:event][:room_ids] ||= []
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        flash[:notice] = 'Event was successfully updated.'
        format.html { redirect_to(@event) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    respond_to do |format|
        flash[:notice] = "#{@event.title} successfully cancelled."
      format.html { redirect_to("/") }
      format.xml  { head :ok }
    end
  end
end
