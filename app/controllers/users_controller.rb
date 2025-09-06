class UsersController < ApplicationController
  skip_before_action :require_user, only: [:index, :create, :sign_in, :authenticate]
  
  def index
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      session[:user_id] = @user.id
      render :sign_in
    else
      render :index
    end
  end

  def sign_in
    @user = User.new
  end

  def authenticate
    @user = User.find_by(email: params[:email])
    
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to dashboard_path, notice: 'Signed in successfully!'
    else
      flash.now[:alert] = 'Invalid email or password'
      render :sign_in
    end
  end

  def dashboard
    @rooms = Room.all.order(created_at: :desc)
    @room = Room.new
    
    if params[:room_id]
      @room_selected = Room.find_by(id: params[:room_id])
      if @room_selected
        @messages = @room_selected.messages.includes(:user).order(created_at: :asc)
        @message = Message.new
      end
    end
  end
  
  def sign_out
    session[:user_id] = nil
    redirect_to root_path, notice: 'Signed out successfully!'
  end

  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end