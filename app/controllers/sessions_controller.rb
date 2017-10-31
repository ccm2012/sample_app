class SessionsController < ApplicationController
  def new; end

  def create
    session = params[:session]
    user = User.find_by email: session[:email].downcase

    if check_user_authenticate user
      user.activated? ? user_authenticated(user, session) : user_not_activate
    else
      user_not_authenticated
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def user_authenticated user, session
    log_in user
    user_authenticated_next user, session
    redirect_to user
  end

  def user_authenticated_next user, session
    if session[:remember_me] == (t "controller.numb_one")
      user.remember
      remember user
    else
      forget user
    end
  end

  def user_not_activate
    flash.now[:warning] = t "sessions.user_not_active"
    render :new
  end

  def user_not_authenticated
    flash.now[:danger] = t "sessions.flash_dange"
    render :new
  end

  def check_user_authenticate user
    user && user.authenticate(params[:session][:password])
  end
end
