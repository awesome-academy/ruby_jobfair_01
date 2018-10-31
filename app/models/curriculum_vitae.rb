class CurriculumVitae < ApplicationRecord
  has_many :user_curriculum_vitaes, dependent: :destroy
  has_many :users, through: :user_curriculum_vitaes, dependent: :destroy

  validates :target, :experience, presence: true,
    length: {maximum: Settings.max_length_target}
  validates :skill, presence: true, length: {maximum: Settings.max_length_rank}
  validates :level, length: {maximum: Settings.max_length_level}
  validates :experience, length: {maximum: Settings.max_length_experience}
  validates :language, presence: true,
    length: {maximum: Settings.max_length_lang}
  validates :note, length: {maximum: Settings.max_length_note}
end
