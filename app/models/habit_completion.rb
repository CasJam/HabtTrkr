class HabitCompletion < ApplicationRecord
  belongs_to :habit

  validates :completed_on, presence: true
  validates :habit_id, uniqueness: { scope: :completed_on }

  scope :for_date, ->(date) { where(completed_on: date) }
  scope :for_habit, ->(habit) { where(habit: habit) }
end
