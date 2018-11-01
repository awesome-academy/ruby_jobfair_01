class ApplicationController < ActionController::Base
  include SessionsHelper
  protect_from_forgery with: :exception
  before_action :set_locale

  def route_not_found
    flash[:warning] = t "not_exist"
    redirect_to root_path
  end

  private

  def default_url_options
    {locale: I18n.locale}
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def logged_in_user
    return if logged_in?
    flash[:danger] = t "r_login"
    redirect_to login_url
  end
end
