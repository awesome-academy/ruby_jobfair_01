class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest

  has_many :user_curriculum_vitaes, dependent: :destroy
  has_many :curriculum_vitaes, through: :user_curriculum_vitaes,
   dependent: :destroy
  has_many :user_jobs, dependent: :destroy
  has_many :jobs, through: :user_jobs, dependent: :destroy

  validates :name, presence: true, length: {maximum: Settings.max_length_name}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: Settings.max_length_mail},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true,
    length: {minimum: Settings.min_length_pass}, allow_nil: true
  validate :birth_day
  validates :birthday, presence: true, date: true
  validates :phone, presence: true, numericality: true,
    length: {minimum: Settings.min_length_phone,
             maximum: Settings.max_length_phone}
  validates :address, presence: true, length: {maximum: Settings.max_length_add}
  enum role: %i(employeer candidate)
  validates :role, inclusion: {in: roles.keys}
  enum gender: %i(male female)
  validates :gender, inclusion: {in: genders.keys}
  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update remember_digest: nil
  end

  def current_user? user
    self == user
  end

  def activate
    update activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update reset_digest: User.digest(reset_token)
    update reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < Settings.expire_time.hours.ago
  end

  private

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def birth_day
    return unless birthday.presence
    old = Date.current.year - birthday.year
    return if birthday < Date.current
    return if old > Settings.old
    errors.add :birthday, I18n.t(".birth_day")
  end
end
