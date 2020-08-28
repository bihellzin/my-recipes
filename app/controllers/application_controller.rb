class ApplicationController < ActionController::Base
  helper_method :current, :logged_in?

  def current_chef
    @current_chef ||= Chef.find(session[:chef_id]) if session[:chef_id]
  end

  def logged_in?
    !!current_chef
  end

  def require_user
    if !logged_in?
      flash[:danger] = 'You are not logged in'
      redirect_to root_path
    end
  end
end
