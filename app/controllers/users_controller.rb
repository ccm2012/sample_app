class UsersController < ApplicationController
  attr_reader :user
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :correct_user, only: %i(show edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate page: params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if user.save
      log_in user
      flash[:success] = t "static_pages.home_h1"
      redirect_to user
    else
      render :new
    end
  end

  def show
    @user = User.find_by id: params[:id]

    redirect_to signup_path unless user
  end

  def edit
    @user = User.find_by id: params[:id]
  end

  def update
    @user = User.find_by id: params[:id]

    if user.update_attributes user_params
      flash[:success] = t "controller.profile_update"
      redirect_to user
    else
      render :edit
    end
  end

  def destroy
    user = User.find_by id: params[:id]
    user.destroy if user
    flash[:success] = t "controller.delete_user"
    redirect_to users_url
  end

  private

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "controller.need_login"
    redirect_to login_path
  end

  def correct_user
    @user = User.find_by_id params[:id]

    redirect_to root_url unless current_user? user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end
end
