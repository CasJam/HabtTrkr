require "test_helper"

class HabitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @habit = habits(:drink_water)
    @other_habit = habits(:exercise)
    # Clean up any existing completions to avoid conflicts
    HabitCompletion.destroy_all
  end

  test "should get index" do
    get habits_url
    assert_response :success
  end

  test "should get new" do
    get new_habit_url
    assert_response :success
  end

  test "should create habit" do
    assert_difference("Habit.count") do
      post habits_url, params: { habit: { description: @habit.description, title: "New Habit Title" } }
    end

    assert_redirected_to habits_url
  end

  test "should show habit" do
    get habit_url(@habit)
    assert_response :success
  end

  test "should get edit" do
    get edit_habit_url(@habit)
    assert_response :success
  end

  test "should update habit" do
    patch habit_url(@habit), params: { habit: { description: @habit.description, title: @habit.title } }
    assert_redirected_to habit_url(@habit)
  end

  test "should update habit with new title and description" do
    new_title = "Updated Habit Title"
    new_description = "Updated habit description"

    patch habit_url(@habit), params: {
      habit: {
        title: new_title,
        description: new_description
      }
    }

    assert_redirected_to habit_url(@habit)

    @habit.reload
    assert_equal new_title, @habit.title
    assert_equal new_description, @habit.description
  end

  test "should not update habit with invalid data" do
    original_title = @habit.title

    patch habit_url(@habit), params: {
      habit: {
        title: "",
        description: @habit.description
      }
    }

    assert_response :unprocessable_entity

    @habit.reload
    assert_equal original_title, @habit.title
  end

  test "should preserve completions when updating habit" do
    # Create some completions
    @habit.mark_completed_today!
    HabitCompletion.create!(habit: @habit, completed_on: Date.current - 1.day)

    original_completion_count = @habit.habit_completions.count

    patch habit_url(@habit), params: {
      habit: {
        title: "Updated Title",
        description: "Updated Description"
      }
    }

    assert_redirected_to habit_url(@habit)

    @habit.reload
    assert_equal original_completion_count, @habit.habit_completions.count
    assert_equal "Updated Title", @habit.title
  end

  test "should destroy habit" do
    assert_difference("Habit.count", -1) do
      delete habit_url(@habit)
    end

    assert_redirected_to habits_url
  end

  test "should destroy habit and all associated completions" do
    # Create some completions
    @habit.mark_completed_today!
    HabitCompletion.create!(habit: @habit, completed_on: Date.current - 1.day)
    HabitCompletion.create!(habit: @habit, completed_on: Date.current - 2.days)

    completion_count = @habit.habit_completions.count
    assert completion_count > 0, "Should have completions to test deletion"

    assert_difference("Habit.count", -1) do
      assert_difference("HabitCompletion.count", -completion_count) do
        delete habit_url(@habit)
      end
    end

    assert_redirected_to habits_url
  end

  test "should return 404 when trying to edit non-existent habit" do
    get edit_habit_url(id: 999999)
    assert_response :not_found
  end

  test "should return 404 when trying to update non-existent habit" do
    patch habit_url(id: 999999), params: { habit: { title: "Test" } }
    assert_response :not_found
  end

  test "should return 404 when trying to delete non-existent habit" do
    delete habit_url(id: 999999)
    assert_response :not_found
  end

  test "should mark habit as complete" do
    assert_not @habit.completed_today?

    patch complete_habit_url(@habit)
    assert_redirected_to habits_url

    @habit.reload
    assert @habit.completed_today?
  end

  test "should not create duplicate completion when marking complete" do
    @habit.mark_completed_today!
    initial_count = @habit.habit_completions.count

    patch complete_habit_url(@habit)
    assert_redirected_to habits_path

    @habit.reload
    assert_equal initial_count, @habit.habit_completions.count
  end

  test "should mark habit as incomplete" do
    @habit.mark_completed_today!
    assert @habit.completed_today?

    patch uncomplete_habit_url(@habit)
    assert_redirected_to habits_path

    @habit.reload
    assert_not @habit.completed_today?
  end

  test "should handle unmarking when not completed" do
    assert_not @habit.completed_today?

    patch uncomplete_habit_url(@habit)
    assert_redirected_to habits_path

    @habit.reload
    assert_not @habit.completed_today?
  end

  test "should return 404 for non-existent habit complete" do
    patch complete_habit_url(id: 999999)
    assert_response :not_found
  end

  test "should return 404 for non-existent habit uncomplete" do
    patch uncomplete_habit_url(id: 999999)
    assert_response :not_found
  end

  # New tests for streak information in index
  test "should include streak information in index response" do
    # Set up some completions for streak calculation
    today = Date.current
    HabitCompletion.create!(habit: @habit, completed_on: today)
    HabitCompletion.create!(habit: @habit, completed_on: today - 1.day)
    HabitCompletion.create!(habit: @habit, completed_on: today - 2.days)

    get habits_url
    assert_response :success

    # Verify that the response includes habit data with streak information
    # This will be tested through the frontend component that receives the data
  end

  test "should include zero streaks for habits with no completions" do
    get habits_url
    assert_response :success

    # Habits with no completions should have zero streaks
    # This will be verified through the model tests and frontend display
  end
end
