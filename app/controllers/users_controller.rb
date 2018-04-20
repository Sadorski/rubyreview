class UsersController < ApplicationController
  skip_before_action :require_login, only: [:index, :create, :login]
  def index
    @location = Location.pluck(:state).uniq
  end

  def show
    @location = Location.pluck(:state).uniq
  end

  def create
    @loc = Location.new(loc_params)
    @user = User.find_or_create_by(user_params)
    
    if @user.valid?
      @user.location = @loc 
      @user.save
      session[:id] = @user.id
      redirect_to '/events'
    else
      flash[:notice] = @user.errors.full_messages
      redirect_to '/'
    end
    
  end

  def update
    @user = User.find(current_user.id)
    @loc = Location.find_or_create_by(loc_params)
    if @user.update_attributes(edit_params)
      @user.location = @loc
      @user.save
      redirect_to '/events'
    else
      redirect_to "/user/#{current_user.id}"
    end
  end

  def login
    @user = User.find_by_email(params[:user][:email]).try(:authenticate, params[:user][:password])

    puts "Helloooo"
    puts @user, "---------------------------------------------------------"
    if @user
      session[:id] = @user.id
      redirect_to "/events"
    else
      flash[:notice] = ["Incorrect Email or Password"]
      redirect_to "/"
    end
  end

    def logout
      session[:id] = nil
      redirect_to '/'
    end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
  def edit_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end
  def loc_params
    params.require(:location).permit(:city, :state)
  end

end
