class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(edit update destroy)
  before_action :find_user, only: :show

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "require_check_email"
      redirect_to root_url
    else
      flash[:danger] = t ".error"
      render :new
    end
  end

  def show; end

  private

  def find_user
    @user = User.find_by id: params[:id]

    return if @user
    flash[:danger] = t ".not_found"
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit :role, :name, :email, :birthday, :gender,
      :phone, :address, :password, :password_confirmation
  end
end
