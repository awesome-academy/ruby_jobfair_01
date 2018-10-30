class CurriculumVitaesController < ApplicationController
  before_action :logged_in_user, :candidate_user, only:
   %i(new create edit update destroy)
  before_action :find_cv, only: %i(show edit update destroy)
  before_action :correct_user, only: %i(edit update destroy)

  def new
    @curriculum_vitae = current_user.curriculum_vitaes.new
  end

  def create
    @curriculum_vitae = current_user.curriculum_vitaes.build cv_params

    if @curriculum_vitae.save
      @curriculum_vitae.user_curriculum_vitaes.create! user_id: current_user.id,
        curriculum_vitae_id: @curriculum_vitae.id
      flash[:success] = t ".success"
      redirect_to @curriculum_vitae
    else
      flash[:danger] = t ".fail"
      render :new
    end
  end

  def show
    @user = @curriculum_vitae.users.find_by role: "candidate"
    @applieds = @curriculum_vitae.users.employeer
    if @user
      respond_to do |format|
        format.html
        format.pdf do
          render pdf: "#{@user.name}_#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}"
        end
      end
    else
      flash[:danger] = t "not_found_cv"
    end
  end

  def edit; end

  def update
    if @curriculum_vitae.update cv_params
      flash[:success] = t ".success"
      redirect_to @curriculum_vitae
    else
      flash[:danger] = t ".failed"
      render :edit
    end
  end

  def destroy
    if @curriculum_vitae.destroy
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".failed"
    end
    redirect_to root_url
  end

  private

  def find_cv
    @curriculum_vitae = CurriculumVitae.find_by id: params[:id]

    return if @curriculum_vitae
    flash[:danger] = t ".not_found"
    redirect_to root_path
  end

  def cv_params
    params.require(:curriculum_vitae).permit :target, :skill, :level,
      :experience, :language, :note
  end

  def candidate_user
    return if current_user.candidate?
    flash[:danger] = t ".permit"
    redirect_to root_url
  end

  def correct_user
    @cv = current_user.curriculum_vitaes.find_by id: @curriculum_vitae.id

    return if @cv
    flash[:danger] = t ".permit"
    redirect_to root_url
  end
end
