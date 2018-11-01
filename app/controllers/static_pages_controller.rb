class StaticPagesController < ApplicationController
  def home
    @career_options = Job.career_options
    @jobs = Job.selected.job_expired.ordered.page(params[:page])
               .per Settings.per_sheet
  end
end
