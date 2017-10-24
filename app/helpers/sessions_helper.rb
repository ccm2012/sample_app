module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  def remember user
    cookies.permanent.signed[:user_id] = user.id
    remember_next user.remember_token
  end

  def remember_next token
    cookies.permanent[:remember_token] = token
  end

  def current_user
    if (user_id_session = session[:user_id])
      @current_user ||= User.find_by id: user_id_session
    elsif (user_id_cookie = cookies.signed[:user_id])
      user = User.find_by id: user_id_cookie

      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def current_user? user
    user == current_user
  end

  def logged_in?
    current_user.present?
  end

  def forget user
    user.forget
    cookies.delete :user_id
    cookies.delete :remember_token
  end

  def log_out
    forget current_user
    session.delete :user_id
    @current_user = nil
  end

  def redirect_back_or default
    redirect_to session[:forwarding_url] || default
    session.delete :forwarding_url
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
