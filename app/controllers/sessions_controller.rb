class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if check_user_authenticate user
      log_in user
      redirect_to user
    else
      flash.now[:danger] = t "sessions.flash_dange"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  private

  def check_user_authenticate user
    user && user.authenticate(params[:session][:password])
  end
end
