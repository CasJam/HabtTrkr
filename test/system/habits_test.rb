require "application_system_test_case"

class HabitsTest < ApplicationSystemTestCase
  setup do
    @habit = habits(:drink_water)
    @other_habit = habits(:exercise)
    # Clean up any existing completions to avoid conflicts
    HabitCompletion.destroy_all
  end

  test "visiting the index" do
    visit habits_url

    assert_selector "h1", text: "HabtTrkr!"
  end

  test "should create habit" do
    visit habits_url
    click_on "Create New Habit"

    fill_in "Title", with: "Test Habit"
    fill_in "Description", with: "Test Description"
    click_on "Create Habit"

    assert_text "Habit was successfully created"
    assert_text "Test Habit"
  end

  test "should edit habit" do
    visit habits_url

    # Find the specific habit and click Edit
    habit_container = find(".habit-item", text: @habit.title)
    within habit_container do
      click_on "Edit"
    end

    # Should be on edit page
    assert_text "Edit Habit"

    # Update the habit
    fill_in "Title", with: "Updated Habit Title"
    fill_in "Description", with: "Updated habit description"
    click_on "Update Habit"

    # Should redirect back and show updated content
    assert_text "Habit was successfully updated"
    assert_text "Updated Habit Title"
    assert_text "Updated habit description"
  end

  # test "should not update habit with invalid data" do
  #   visit edit_habit_url(@habit)

  #   # Clear the title (making it invalid)
  #   fill_in "Habit Title", with: ""
  #   click_on "Update Habit"

  #   # Should stay on edit page with error - Rails validation message for title field
  #   assert_text "can't be blank"
  #   assert_current_path edit_habit_path(@habit)
  # end

  test "should delete habit" do
    visit habits_url

    # Confirm habit exists
    assert_text @habit.title

    # Delete the habit (this will need confirmation)
    habit_container = find(".habit-item", text: @habit.title)
    within habit_container do
      accept_confirm do
        click_on "Delete"
      end
    end

    # Should redirect and show success message
    assert_text "Habit was successfully deleted"
    assert_no_text @habit.title
  end

  test "should preserve completions when editing habit" do
    # Mark habit as complete first
    @habit.mark_completed_today!

    visit edit_habit_url(@habit)

    # Update the habit
    fill_in "Title", with: "Updated Title"
    click_on "Update Habit"

    # Visit the habits page and verify completion is preserved
    visit habits_url
    assert_text "Updated Title"
    assert_text "✓ Completed today"
  end

  test "should mark habit as complete and incomplete" do
    visit habits_url

    # Wait for page to load and find the habit by using a more specific selector
    assert_text @habit.title

    # Find the specific habit container and click Mark Complete
    habit_container = find(".habit-item", text: @habit.title)
    within habit_container do
      click_on "Mark Complete"
    end

    # Should show success message and completed status
    assert_text "marked as complete"
    assert_text "✓ Completed today"

    # Should show Mark Incomplete button now
    habit_container = find(".habit-item", text: @habit.title)
    within habit_container do
      click_on "Mark Incomplete"
    end

    # Should show success message and incomplete status
    assert_text "marked as incomplete"
    habit_container = find(".habit-item", text: @habit.title)
    within habit_container do
      assert_text "Mark Complete"
    end
  end

  test "should display current streak for habit" do
    # Create a 3-day streak
    today = Date.current
    HabitCompletion.create!(habit: @habit, completed_on: today)
    HabitCompletion.create!(habit: @habit, completed_on: today - 1.day)
    HabitCompletion.create!(habit: @habit, completed_on: today - 2.days)

    visit habits_url

    assert_text @habit.title
    assert_text "Current Streak"
    assert_text "3 days"
  end

  test "should display zero streak for new habit" do
    visit habits_url

    assert_text @habit.title
    assert_text "Current Streak"
    assert_text "0 days"
  end

  test "should display longest streak" do
    # Create a pattern: 5-day current streak, gap, 3-day old streak
    today = Date.current

    # Current streak of 5 days
    5.times do |i|
      HabitCompletion.create!(habit: @habit, completed_on: today - i.days)
    end

    # Gap of 2 days

    # Previous streak of 3 days
    3.times do |i|
      HabitCompletion.create!(habit: @habit, completed_on: today - 7.days - i.days)
    end

    visit habits_url

    assert_text @habit.title
    assert_text "Current Streak"
    assert_text "5 days"
    assert_text "Longest Streak"
    assert_text "5 days"
  end

  test "should display total completions" do
    # Create some completions with gaps
    today = Date.current
    HabitCompletion.create!(habit: @habit, completed_on: today)
    HabitCompletion.create!(habit: @habit, completed_on: today - 1.day)
    HabitCompletion.create!(habit: @habit, completed_on: today - 3.days)
    HabitCompletion.create!(habit: @habit, completed_on: today - 5.days)

    visit habits_url

    assert_text @habit.title
    assert_text "Total"
    assert_text "4 completions"
  end

  test "should update streak display after marking complete" do
    # Start with a 2-day streak (yesterday and day before)
    today = Date.current
    HabitCompletion.create!(habit: @habit, completed_on: today - 1.day)
    HabitCompletion.create!(habit: @habit, completed_on: today - 2.days)

    visit habits_url

    # Should show 0 streak (not completed today)
    assert_text "Current Streak"
    assert_text "0 days"

    # Mark complete today
    habit_container = find(".habit-item", text: @habit.title)
    within habit_container do
      click_on "Mark Complete"
    end

    # Should now show 3-day streak
    assert_text "3 days"
  end

  test "should display all habits in a list" do
    visit habits_url

    # Verify that all fixture habits are displayed
    assert_text "Drink 8 glasses of water"
    assert_text "Stay hydrated throughout the day by drinking water regularly"

    assert_text "30 minutes of exercise"
    assert_text "Daily cardio or strength training to maintain fitness"

    assert_text "Read for 20 minutes"
    assert_text "Read books to expand knowledge and improve focus"

    assert_text "10 minutes meditation"
    # This habit has no description, so we shouldn't see any description for it

    # Verify that each habit has View and Edit buttons
    habits_count = Habit.count
    assert_selector "a", text: "View", count: habits_count
    assert_selector "a", text: "Edit", count: habits_count

    # Verify that we can see the "Create New Habit" button
    assert_selector "a", text: "Create New Habit"
  end

  test "should create a habit" do
    visit habits_url
    click_on "Create New Habit"

    fill_in "Habit Title", with: "Morning yoga"
    fill_in "Description", with: "10 minutes of yoga every morning"
    click_on "Create Habit"

    assert_text "Habit was successfully created"
    assert_text "Morning yoga"
    assert_text "10 minutes of yoga every morning"
  end

  test "should create a habit without description" do
    visit habits_url
    click_on "Create New Habit"

    fill_in "Habit Title", with: "Take vitamins"
    click_on "Create Habit"

    assert_text "Habit was successfully created"
    assert_text "Take vitamins"
  end

  test "should not create habit with empty title" do
    visit habits_url
    click_on "Create New Habit"

    fill_in "Description", with: "Some description"
    click_on "Create Habit"

    assert_current_path new_habit_path
  end

  test "should show a habit" do
    visit habits_url
    click_on "View", match: :first

    assert_text "Created on"
  end

  test "should update a habit" do
    visit habit_url(@habit)
    click_on "Edit"

    fill_in "Habit Title", with: "Updated habit title"
    fill_in "Description", with: "Updated description"
    click_on "Update Habit"

    assert_text "Habit was successfully updated"
    assert_text "Updated habit title"
    assert_text "Updated description"
  end

  # test "should not update habit with empty title" do
  #   visit habit_url(@habit)
  #   click_on "Edit"

  #   fill_in "Habit Title", with: ""
  #   click_on "Update Habit"

  #   assert_current_path edit_habit_path(@habit)
  # end

  test "should destroy a habit" do
    visit habit_url(@habit)

    accept_confirm do
      click_on "Delete"
    end

    assert_text "Habit was successfully deleted"
    assert_current_path habits_path
  end

  test "should show empty state when no habits exist" do
    # Properly clean up with foreign key constraints
    HabitCompletion.destroy_all
    Habit.destroy_all

    visit habits_url

    assert_text "No habits yet"
    assert_text "Get started by creating your first habit to track"
    assert_selector "a", text: "Create Your First Habit"
  end

  test "should navigate between pages correctly" do
    visit habits_url

    # Go to new habit page
    click_on "Create New Habit"
    assert_current_path new_habit_path

    # Go back to habits
    click_on "Back to Habits"
    assert_current_path habits_path

    # Go to first habit's show page
    click_on "View", match: :first
    assert_text "Created on"  # Verify we're on a habit show page

    # Go to edit
    click_on "Edit"
    assert_text "Edit Habit"  # Verify we're on the edit page

    # Go back to habit
    click_on "Back to Habit"
    assert_text "Created on"  # Verify we're back on the show page
  end

  test "should show helpful tips on new habit page" do
    visit new_habit_url

    assert_text "Tips for creating effective habits"
    assert_text "Make it specific and measurable"
    assert_text "Start small and build up gradually"
    assert_text "Focus on consistency over perfection"
  end

  test "should show placeholder for tracking features" do
    visit habit_url(@habit)

    assert_text "Tracking"
    assert_text "Habit tracking features coming soon!"
  end

  test "should display habit creation and update timestamps" do
    visit habit_url(@habit)

    assert_text "Created on"

    click_on "Edit"
    fill_in "Habit Title", with: "Updated title for timestamp test"
    click_on "Update Habit"

    click_on "Edit"
    assert_text "Created on"
    assert_text "Last updated on"
  end

  test "should mark habit as completed for today" do
    visit habits_url

    # Wait for the page to fully load
    assert_text "HabtTrkr"
    assert_text "Mark Complete"

    # Initially should have 4 Mark Complete buttons (all habits from fixtures)
    initial_complete_count = page.all('button', text: 'Mark Complete').size
    initial_incomplete_count = page.all('button', text: 'Mark Incomplete').size
    assert_equal 4, initial_complete_count
    assert_equal 0, initial_incomplete_count

    # Mark as completed
    click_on "Mark Complete", match: :first

    # Should have one less "Mark Complete" and one more "Mark Incomplete" button
    new_complete_count = page.all('button', text: 'Mark Complete').size
    new_incomplete_count = page.all('button', text: 'Mark Incomplete').size

    assert_equal 3, new_complete_count
    assert_equal 1, new_incomplete_count
    assert_text "✓ Completed today"
  end

  test "should unmark habit completion for today" do
    # Mark habit as completed first
    @habit.mark_completed_today!

    visit habits_url

    # Wait for page load and check initial state
    assert_text "HabtTrkr"
    assert_text "Mark Incomplete"

    # Should show as completed initially
    assert_selector "button", text: "Mark Incomplete"
    assert_text "✓ Completed today"

    # Unmark completion
    click_on "Mark Incomplete", match: :first

    # Should show as not completed
    assert_selector "button", text: "Mark Complete"
    assert_no_selector "button", text: "Mark Incomplete"
    assert_no_text "✓ Completed today"
  end

  test "should display completion status for multiple habits" do
    # Mark one habit as completed
    @habit.mark_completed_today!

    visit habits_url

    # Wait for page load
    assert_text "HabtTrkr"

    # Should have multiple habits (we know from fixtures there are 4)
    habits_count = page.all('button', text: /Mark (Complete|Incomplete)/).count
    assert_operator habits_count, :>=, 4

    # Should have at least one completed and one incomplete
    assert_selector "button", text: "Mark Incomplete"
    assert_selector "button", text: "Mark Complete"
    assert_text "✓ Completed today"
  end

  test "should show flash message after marking complete" do
    visit habits_url

    # Wait for page load
    assert_text "HabtTrkr"
    assert_text "Mark Complete"

    # Get the first habit title to match against flash message
    first_habit = Habit.order(:created_at).first

    click_on "Mark Complete", match: :first

    # Flash message includes the habit title
    assert_text "#{first_habit.title} marked as complete for today!"
  end

  test "should show flash message after marking incomplete" do
    @habit.mark_completed_today!
    visit habits_url

    # Wait for page load
    assert_text "HabtTrkr"
    assert_text "Mark Incomplete"

    click_on "Mark Incomplete", match: :first

    # Flash message includes the habit title and says "marked as incomplete"
    assert_text "#{@habit.title} marked as incomplete for today."
  end

    test "should display 14-day streak calendar at the top of the page" do
    visit habits_url

    # Should show a 14-day calendar section
    assert_text "14-Day Overview"

    # Should show dates for the past 14 days
    14.times do |i|
      date = Date.current - i.days
      assert_text date.day.to_s, minimum: 1  # Day number should appear somewhere
    end
  end

  test "should display completion indicators in 14-day calendar" do
    # Create some completions for multiple habits
    today = Date.current

    # Habit 1: completed today, yesterday, and 3 days ago
    @habit.habit_completions.create!(completed_on: today)
    @habit.habit_completions.create!(completed_on: today - 1.day)
    @habit.habit_completions.create!(completed_on: today - 3.days)

    # Habit 2: completed 2 days ago and 5 days ago
    @other_habit.habit_completions.create!(completed_on: today - 2.days)
    @other_habit.habit_completions.create!(completed_on: today - 5.days)

    visit habits_url

    assert_text "14-Day Overview"

    # Should show some form of completion indicators
    # This will vary based on the implementation, but there should be visual indicators
    assert_text "habits completed", minimum: 1
  end

  test "should show current overall streak in 14-day overview" do
    # Create a 3-day streak for one habit
    today = Date.current
    @habit.habit_completions.create!(completed_on: today)
    @habit.habit_completions.create!(completed_on: today - 1.day)
    @habit.habit_completions.create!(completed_on: today - 2.days)

    visit habits_url

    assert_text "14-Day Overview"
    assert_text "Current Streak"
    # For now, we'll track days where any habit was completed
    assert_text "3 days"
  end

  test "should display empty state for 14-day overview when no completions" do
    visit habits_url

    assert_text "14-Day Overview"
    assert_text "Current Streak"
    assert_text "0 days"
  end
end
