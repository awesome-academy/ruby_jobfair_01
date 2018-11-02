class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :find_user, only: :show
  before_action :admin_user, only: %i(index destroy)

  def index
    @users = User.selected.ordered.page(params[:page]).per Settings.per_page
  end

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

  def destroy
    if @user.destroy
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".failed"
    end
    redirect_to users_url
  end

  private

  def find_user
    @user = User.find_by id: params[:id]

    return if @user
    flash[:danger] = t ".not_found"
    redirect_to root_path
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def user_params
    params.require(:user).permit :role, :name, :email, :birthday, :gender,
      :phone, :address, :password, :password_confirmation
  end
end
