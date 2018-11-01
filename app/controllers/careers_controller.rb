class CareersController < ApplicationController
  before_action :logged_in_user, :verify_admin,
    only: %i(index show new edit update)
  before_action :find_career, only: %i(show edit update)

  def index
    @careers = Career.page(params[:page]).per Settings.per_sheet
  end

  def show; end

  def new
    @career = Career.new
  end

  def create
    @career = Career.new career_params

    if @career.save
      flash[:success] = t ".create_career_success"
      redirect_to careers_url
    else
      flash[:danger] = t ".error"
      render :new
    end
  end

  def edit; end

  def update
    if @career.update career_params
      flash[:success] = t ".update_success"
      redirect_to @career
    else
      flash[:danger] = t ".update_fail"
      render :edit
    end
  end

  private

  def career_params
    params.require(:career).permit :name, :description
  end

  def find_career
    @career = Career.find_by id: params[:id]

    return if @career
    flash[:danger] = t ".not_found_careers"
    redirect_to root_path
  end

  def verify_admin
    return if current_user.admin?

    flash[:danger] = t ".permit"
    redirect_to root_url
  end
end
