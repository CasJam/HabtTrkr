require "test_helper"

class HabitTest < ActiveSupport::TestCase
  setup do
    @habit = habits(:drink_water)
    @other_habit = habits(:exercise)
    # Clean up any existing completions to avoid conflicts
    HabitCompletion.destroy_all
  end

  test "should create valid habit with title" do
    habit = Habit.new(title: "Drink water")
    assert habit.valid?
    assert habit.save
  end

  test "should create valid habit with title and description" do
    habit = Habit.new(title: "Exercise", description: "30 minutes of cardio daily")
    assert habit.valid?
    assert habit.save
  end

  test "should not create habit without title" do
    habit = Habit.new(description: "Some description")
    assert_not habit.valid?
    assert_includes habit.errors[:title], "can't be blank"
  end

  test "should not create habit with empty title" do
    habit = Habit.new(title: "")
    assert_not habit.valid?
    assert_includes habit.errors[:title], "can't be blank"
  end

  test "should not create habit with title longer than 100 characters" do
    long_title = "a" * 101
    habit = Habit.new(title: long_title)
    assert_not habit.valid?
    assert_includes habit.errors[:title], "is too long (maximum is 100 characters)"
  end

  test "should create habit with title exactly 100 characters" do
    title_100_chars = "a" * 100
    habit = Habit.new(title: title_100_chars)
    assert habit.valid?
  end

  test "should not create habit with description longer than 500 characters" do
    long_description = "a" * 501
    habit = Habit.new(title: "Valid title", description: long_description)
    assert_not habit.valid?
    assert_includes habit.errors[:description], "is too long (maximum is 500 characters)"
  end

  test "should create habit with description exactly 500 characters" do
    description_500_chars = "a" * 500
    habit = Habit.new(title: "Valid title", description: description_500_chars)
    assert habit.valid?
  end

  test "should create habit with empty description" do
    habit = Habit.new(title: "Valid title", description: "")
    assert habit.valid?
  end

  test "should create habit with nil description" do
    habit = Habit.new(title: "Valid title", description: nil)
    assert habit.valid?
  end

  test "should have timestamps after creation" do
    habit = Habit.create!(title: "Test habit")
    assert_not_nil habit.created_at
    assert_not_nil habit.updated_at
  end

  test "should have many habit completions" do
    assert_respond_to @habit, :habit_completions
  end

  test "should check if completed today" do
    assert_not @habit.completed_today?

    @habit.mark_completed_today!
    assert @habit.completed_today?
  end

  test "should check if completed on specific date" do
    date = Date.current - 1.day
    assert_not @habit.completed_on?(date)

    HabitCompletion.create!(habit: @habit, completed_on: date)
    assert @habit.completed_on?(date)
  end

  test "should mark completed today" do
    assert_not @habit.completed_today?

    result = @habit.mark_completed_today!
    assert result
    assert @habit.completed_today?
  end

  test "should not create duplicate completion for today" do
    @habit.mark_completed_today!

    # Should return false when trying to mark completed again
    result = @habit.mark_completed_today!
    assert_not result

    # Should still be completed
    assert @habit.completed_today?

    # Should only have one completion record
    assert_equal 1, @habit.habit_completions.count
  end

  test "should unmark completed today" do
    @habit.mark_completed_today!
    assert @habit.completed_today?

    result = @habit.unmark_completed_today!
    assert result
    assert_not @habit.completed_today?
  end

  test "should return false when unmarking if not completed today" do
    assert_not @habit.completed_today?

    result = @habit.unmark_completed_today!
    assert_not result
  end

  # New streak calculation tests
  test "should return zero streak when no completions" do
    assert_equal 0, @habit.current_streak
  end

  test "should return 1 for streak when completed today only" do
    @habit.mark_completed_today!
    assert_equal 1, @habit.current_streak
  end

  test "should calculate streak for consecutive days" do
    today = Date.current
    # Complete for the last 3 days including today
    HabitCompletion.create!(habit: @habit, completed_on: today)
    HabitCompletion.create!(habit: @habit, completed_on: today - 1.day)
    HabitCompletion.create!(habit: @habit, completed_on: today - 2.days)

    assert_equal 3, @habit.current_streak
  end

  test "should reset streak when there's a gap" do
    today = Date.current
    # Complete today and 2 days ago (with gap yesterday)
    HabitCompletion.create!(habit: @habit, completed_on: today)
    HabitCompletion.create!(habit: @habit, completed_on: today - 2.days)

    assert_equal 1, @habit.current_streak
  end

  test "should calculate streak when not completed today but completed yesterday" do
    today = Date.current
    # Complete yesterday and day before (but not today)
    HabitCompletion.create!(habit: @habit, completed_on: today - 1.day)
    HabitCompletion.create!(habit: @habit, completed_on: today - 2.days)

    assert_equal 0, @habit.current_streak
  end

  test "should handle long streaks correctly" do
    today = Date.current
    # Create a 10-day streak ending today
    10.times do |i|
      HabitCompletion.create!(habit: @habit, completed_on: today - i.days)
    end

    assert_equal 10, @habit.current_streak
  end

  test "should calculate longest streak" do
    today = Date.current

    # Create completions: 3-day streak, 1-day gap, 5-day streak, 2-day gap, 2-day streak
    # Current streak (5 days ending today)
    5.times do |i|
      HabitCompletion.create!(habit: @habit, completed_on: today - i.days)
    end

    # Gap of 2 days

    # Previous streak of 3 days
    3.times do |i|
      HabitCompletion.create!(habit: @habit, completed_on: today - 7.days - i.days)
    end

    # Gap of 1 day

    # Oldest streak of 2 days
    2.times do |i|
      HabitCompletion.create!(habit: @habit, completed_on: today - 11.days - i.days)
    end

    assert_equal 5, @habit.current_streak
    assert_equal 5, @habit.longest_streak
  end

  test "should return zero for longest streak when no completions" do
    assert_equal 0, @habit.longest_streak
  end

  test "should calculate total completions" do
    today = Date.current

    # Create some completions with gaps
    HabitCompletion.create!(habit: @habit, completed_on: today)
    HabitCompletion.create!(habit: @habit, completed_on: today - 1.day)
    HabitCompletion.create!(habit: @habit, completed_on: today - 3.days)
    HabitCompletion.create!(habit: @habit, completed_on: today - 5.days)

    assert_equal 4, @habit.total_completions
  end
end
