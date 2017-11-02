class UsersController < ApplicationController
  attr_reader :user
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :find_user, only: %i(show edit update destroy correct_user)
  before_action :correct_user, only: %i(show edit update)
  before_action :admin_user, only: :destroy

  def index
    list = current_user.return_admin_index
    @users = list.paginate page: params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if user.save
      user.send_activation_email
      flash[:info] = t "static_pages.check_h1"
      redirect_to root_url
    else
      render :new
    end
  end

  def show
    redirect_to signup_path unless user
  end

  def edit; end

  def update
    if user.update_attributes user_params
      flash[:success] = t "controller.profile_update"
      redirect_to user
    else
      render :edit
    end
  end

  def destroy
    user.destroy if user
    flash[:success] = t "controller.delete_user"
    redirect_to users_url
  end

  private

  def find_user
    @user = User.find_by id: params[:id]
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "controller.need_login"
    redirect_to login_path
  end

  def correct_user
    redirect_to root_url unless user.equal_user? current_user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end
end
