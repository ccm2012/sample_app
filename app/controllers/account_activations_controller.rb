class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]

    if user && !user.activated? &&
      user.authenticated?(:activation, params[:id])
      user.activate
      edit_user user
    else
      flash[:danger] = t "static_pages.fail_home_h1"
      redirect_to root_url
    end
  end

  private

  def edit_user user
    log_in user
    flash[:success] = t "static_pages.active_good"
    redirect_to user
  end
end
