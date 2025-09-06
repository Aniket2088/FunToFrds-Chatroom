# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  helper_method :current_user
  
  private
  
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
  
  def require_user
    unless current_user
      redirect_to signin_path, alert: 'You must be signed in to access that page.'
    end
  end
end