class PasswordResetsController < ApplicationController
  attr_reader :user

  before_action :find_user, only: %i(edit update)

  def new; end

  def create
    user = User.find_by email: params[:password_reset][:email].downcase

    if user
      user.create_reset_digest
      user.send_password_reset_email
      send_reset_pass_next
    else
      fail_send_reset_pass
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      user.errors.add :password, (t "controller.pass_empty_err")
      edit_render
    elsif user.update_attributes user_params
      success_reset_pass user
    else
      edit_render
    end
  end

  private

  def fail_send_reset_pass
    flash.now[:danger] = t "controller.fail_sent_acc"
    render :new
  end

  def send_reset_pass_next
    flash[:info] = t "controller.success_sent_acc"
    redirect_to root_url
  end

  def success_reset_pass user
    log_in user
    flash[:success] = t "controller.success_reset_pass"
    redirect_to user
  end

  def edit_render
    render :edit
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def find_user
    @user = User.find_by email: params[:email]
    check_and_valid_user
    check_expiration
  end

  def check_and_valid_user
    return if user && user.activated? &&
      user.authenticated?(:reset, params[:id])
    flash[:danger] = t "controller.check_valid_user"
    redirect_to root_url
  end

  def check_expiration
    return unless user.password_reset_expired?
    flash[:danger] = t "controller.check_expired"
    redirect_to new_password_reset_url
  end
end
