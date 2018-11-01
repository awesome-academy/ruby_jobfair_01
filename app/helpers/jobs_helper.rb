module JobsHelper
  def jobs_new job
    @user = job.users.find_by role: "employeer"
  end

  def check_expire? job
    return true if job.expiration_date > Date.current
  end

  def new_job? job
    date = Date.current - Job.find_by(id: job.id).created_at.to_date
    return true if date < Settings.new_job
  end
end
