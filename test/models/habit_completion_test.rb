require "test_helper"

class HabitCompletionTest < ActiveSupport::TestCase
  setup do
    @habit = habits(:drink_water)
    @other_habit = habits(:exercise)
    @today = Date.current
    # Clean up any existing completions to avoid conflicts
    HabitCompletion.destroy_all
  end

  test "should create habit completion" do
    completion = HabitCompletion.new(habit: @habit, completed_on: @today)
    assert completion.valid?
    assert completion.save
  end

  test "should require habit" do
    completion = HabitCompletion.new(completed_on: @today)
    assert_not completion.valid?
    assert_includes completion.errors[:habit], "must exist"
  end

  test "should require completed_on date" do
    completion = HabitCompletion.new(habit: @habit)
    assert_not completion.valid?
    assert_includes completion.errors[:completed_on], "can't be blank"
  end

  test "should not allow duplicate completions for same habit and date" do
    # Create first completion
    HabitCompletion.create!(habit: @habit, completed_on: @today)

    # Try to create duplicate
    duplicate = HabitCompletion.new(habit: @habit, completed_on: @today)
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:habit_id], "has already been taken"
  end

  test "should allow completion for different dates" do
    HabitCompletion.create!(habit: @habit, completed_on: @today)
    yesterday_completion = HabitCompletion.new(habit: @habit, completed_on: @today - 1.day)
    assert yesterday_completion.valid?
    assert yesterday_completion.save
  end

  test "should allow different habits on same date" do
    HabitCompletion.create!(habit: @habit, completed_on: @today)
    other_completion = HabitCompletion.new(habit: @other_habit, completed_on: @today)
    assert other_completion.valid?
    assert other_completion.save
  end

  test "should belong to habit" do
    completion = HabitCompletion.new(habit: @habit, completed_on: @today)
    assert_equal @habit, completion.habit
  end

  test "should have scope for today" do
    # Create completions for different dates
    HabitCompletion.create!(habit: @habit, completed_on: @today)
    HabitCompletion.create!(habit: @other_habit, completed_on: @today - 1.day)

    today_completions = HabitCompletion.for_date(@today)
    assert_equal 1, today_completions.count
    assert_equal @today, today_completions.first.completed_on
  end

  test "should have scope for habit" do
    HabitCompletion.create!(habit: @habit, completed_on: @today)
    HabitCompletion.create!(habit: @other_habit, completed_on: @today)

    habit_completions = HabitCompletion.for_habit(@habit)
    assert_equal 1, habit_completions.count
    assert_equal @habit, habit_completions.first.habit
  end
end
