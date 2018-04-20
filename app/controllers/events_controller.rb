class EventsController < ApplicationController
  before_action :require_login
  def index
    @location = Location.pluck(:state).uniq
    @events = Event.all 
  end

  def show
    @comments = Comment.all
    @event = Event.find(params[:id])
    
  end

  def create
    @event = Event.new(event_params)
    @loc = Location.find_or_create_by(loc_params)
    if @event.valid?
      @event.location = @loc
      @event.save
      redirect_to '/events'
    else
      flash[:notice] = @event.errors.full_messages
      redirect_to '/events'
    end


  end



  def event_params
    params.require(:event).permit(:name, :date, :user_id)
  end

  def loc_params
    params.require(:location).permit(:city, :state)
  end

end
