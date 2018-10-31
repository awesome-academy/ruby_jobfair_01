class Career < ApplicationRecord
  has_many :jobs
  validates :name, presence: true, uniqueness: true,
    length: {maximum: Settings.max_length_name}
  validates :description, length: {maximum: Settings.max_length_career}
end
