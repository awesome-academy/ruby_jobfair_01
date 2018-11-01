class StaticPagesController < ApplicationController
  def home
    @jobs = Job.selected.job_expired.ordered.page(params[:page])
               .per Settings.per_sheet
  end
end
