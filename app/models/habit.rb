class Habit < ApplicationRecord
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 500 }

  has_many :habit_completions, dependent: :destroy

  def completed_today?
    completed_on?(Date.current)
  end

  def completed_on?(date)
    habit_completions.exists?(completed_on: date)
  end

  def mark_completed_today!
    return false if completed_today?

    habit_completions.create(completed_on: Date.current)
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def unmark_completed_today!
    completion = habit_completions.find_by(completed_on: Date.current)
    return false unless completion

    completion.destroy
    true
  end

  def current_streak
    return 0 if habit_completions.empty?

    # Get all completion dates sorted in descending order
    completion_dates = habit_completions.pluck(:completed_on).sort.reverse

    # Start counting from today or the most recent completion
    streak_count = 0
    current_date = Date.current

    # Check if completed today
    if completion_dates.include?(current_date)
      streak_count = 1
      current_date -= 1.day

      # Count consecutive days backwards
      completion_dates.each do |date|
        next if date == Date.current # Skip today, already counted

        if date == current_date
          streak_count += 1
          current_date -= 1.day
        elsif date < current_date
          # Found a gap, streak is broken
          break
        end
      end
    else
      # Not completed today, so current streak is 0
      streak_count = 0
    end

    streak_count
  end

  def longest_streak
    return 0 if habit_completions.empty?

    # Get all completion dates sorted
    completion_dates = habit_completions.pluck(:completed_on).sort

    max_streak = 0
    current_streak = 1

    # Handle single completion
    return 1 if completion_dates.length == 1

    # Iterate through dates to find longest consecutive sequence
    (1...completion_dates.length).each do |i|
      if completion_dates[i] == completion_dates[i-1] + 1.day
        # Consecutive day found
        current_streak += 1
      else
        # Gap found, check if this is the longest streak so far
        max_streak = [max_streak, current_streak].max
        current_streak = 1
      end
    end

    # Check the final streak
    [max_streak, current_streak].max
  end

  def total_completions
    habit_completions.count
  end

  def self.fourteen_day_overview
    today = Date.current
    dates = (0..13).map { |i| today - i.days }.reverse

    # Get all completions for all habits in the last 14 days
    all_completions = HabitCompletion.joins(:habit)
                                    .where(completed_on: dates)
                                    .group(:completed_on)
                                    .count

    # Calculate overall streak (consecutive days with at least one habit completed)
    overall_streak = calculate_overall_streak(all_completions, today)

    {
      dates: dates.map do |date|
        {
          date: date,
          day_number: date.day,
          day_name: date.strftime('%a'),
          habits_completed: all_completions[date] || 0,
          is_today: date == today
        }
      end,
      current_streak: overall_streak
    }
  end

  private

  def self.calculate_overall_streak(completions_by_date, today)
    streak = 0
    current_date = today

    loop do
      break unless completions_by_date[current_date] && completions_by_date[current_date] > 0

      streak += 1
      current_date -= 1.day
    end

    streak
  end
end
