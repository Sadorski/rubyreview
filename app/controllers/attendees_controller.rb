class AttendeesController < ApplicationController
    before_action :require_login
    def delevent
        @event = Event.find(params[:id])
        @event.destroy
        redirect_to '/events'
    end
   
    def cancel
        @event = Event.find(params[:id])
        if @event.attended.exists?(current_user.id)
            @event.attended.delete(current_user)
            redirect_to "/events"
        end
    end
    def comment
        Comment.create(content:params[:content], user_id: current_user.id, event_id: params[:id])
        redirect_to "/events/#{params[:id]}"
    end
    
    def create
        Attendee.create(event_id: params[:id], user_id: current_user.id)
        redirect_to '/events'
    end
    def edit
        @location = Location.pluck(:state).uniq
        @event = Event.find(params[:id])
    end

    def update
        @event = Event.find(params[:id])
        @loc = Location.find_or_create_by(loc_params)
        if @event.update_attributes(event_params)
            @event.location = @loc
            @event.save
            redirect_to '/events'
        else
            flash[:notice] = @event.errors.full_messages
            redirect_to "/events/#{params[:id]}"
        end
    end

    private
    def event_params
        params.require(:event).permit(:name, :date, :user_id)
    end
    def loc_params
        params.require(:location).permit(:city, :state)
    end

end
