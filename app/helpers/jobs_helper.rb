module JobsHelper
  def jobs_new job
    @user = job.users.find_by role: "employeer"
  end

  def check_expire? job
    return true if job.expiration_date > Date.current
  end
end
