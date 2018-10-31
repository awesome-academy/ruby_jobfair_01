class JobsController < ApplicationController
  before_action :logged_in_user, :employeer_user,
    only: %i(new create edit update destroy)
  before_action :find_job, only: %i(show edit update destroy)

  def index
    @jobs = Job.job_expired.ordered.page(params[:page]).per Settings.per_sheet
    %w(career_name company_name job_info).each do |p|
      search_job p, @jobs
    end
  end

  def new
    @career_options = Job.career_options
    @job = current_user.jobs.new
  end

  def create
    @career_options = Job.career_options
    @job = current_user.jobs.build job_params

    if @job.save
      @job.user_jobs.create! user_id: current_user.id, job_id: @job.id
      flash[:success] = t ".success"
      redirect_to @job
    else
      flash[:danger] = t ".error"
      render :new
    end
  end

  def show
    @user = @job.users.find_by role: "employeer"

    return unless logged_in?
    @cv_options = Job.cv_options current_user
    @user_cv = @user.user_curriculum_vitaes.build

    return if @user
    flash[:danger] = t ".user_employeer"
    redirect_to root_path
  end

  def edit
    @career_options = Job.career_options
  end

  def update
    @career_options = Job.career_options
    if @job.update job_params
      flash[:success] = t ".success"
      redirect_to @job
    else
      flash[:danger] = t ".error"
      render :edit
    end
  end

  def destroy
    if @job.destroy
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".error"
    end
    redirect_to root_url
  end

  private

  def find_job
    @job = Job.find_by id: params[:id]

    return if @job
    flash[:danger] = t ".not_found"
    redirect_to root_path
  end

  def employeer_user
    return if current_user.employeer?
    flash[:danger] = t ".not_permit"
    redirect_to root_path
  end

  def search_job option, job
    return unless params[option].present?
    @jobs = job.send(option, params[option]).ordered.page(params[:page])
               .per Settings.per_sheet
  end

  def job_params
    params.require(:job).permit :career_id, :title, :salary, :rank, :skill,
      :language, :amount, :experience, :description,
      :publish_date, :expiration_date
  end
end
