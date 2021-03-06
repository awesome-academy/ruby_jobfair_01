class Job < ApplicationRecord
  belongs_to :career
  has_many :user_jobs, dependent: :destroy
  has_many :users, through: :user_jobs

  validates :title, presence: true, length: {maximum: Settings.max_length_title}
  validates :salary, presence: true, numericality: true
  validates :amount, presence: true, numericality: {only_integer: true}
  validates :rank, :skill, presence: true,
    length: {maximum: Settings.max_length_rank}
  validates :language, presence: true,
    length: {maximum: Settings.max_length_lang}
  validates :experience, :description, presence: true,
    length: {maximum: Settings.max_length_experience}
  validate :end_after_start
  validates :publish_date, :expiration_date, presence: true, date: true

  scope :selected,
    ->{select :id, :title, :salary, :experience, :expiration_date}
  scope :ordered, ->{order created_at: :desc}
  scope :company_name, (lambda do |name|
    includes(:users).where(User.arel_table[:name].matches("%#{name}%")
      .or(User.arel_table[:address].matches("%#{name}%"))).references(:users)
  end)
  scope :job_expired,
    ->{where(Job.arel_table[:expiration_date].gteq(Date.current))}
  scope :job_info, (lambda do |info|
    where(Job.arel_table[:title].matches("%#{info}%")
      .or(Job.arel_table[:rank].matches("%#{info}%")))
  end)
  scope :career_name, (lambda do |name|
    joins(:career).where(Career.arel_table[:name].matches("%#{name}%"))
  end)

  class << self
    def career_options
      @career_options = Career.all.map{|p| [p.name, p.id]}
    end

    def cv_options user
      @cv_options = user.curriculum_vitaes.map{|p| [p.target, p.id]}
    end
  end

  private

  def end_after_start
    return unless publish_date.presence
    return unless expiration_date.presence
    return if expiration_date > publish_date
    errors.add :expiration_date, I18n.t(".expiration_date")
  end
end
