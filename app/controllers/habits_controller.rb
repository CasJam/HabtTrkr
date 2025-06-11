class HabitsController < ApplicationController
  before_action :set_habit, only: %i[ show edit update destroy complete uncomplete ]

  # GET /habits or /habits.json
  def index
    @habits = Habit.all.order(:created_at)
    habits_with_status = @habits.map { |habit| habit_with_completion_status(habit) }
    fourteen_day_data = Habit.fourteen_day_overview

    render inertia: 'Habits/Index', props: {
      habits: habits_with_status,
      fourteen_day_overview: fourteen_day_data
    }
  end

  # GET /habits/1 or /habits/1.json
  def show
    render inertia: 'Habits/Show', props: { habit: @habit }
  end

  # GET /habits/new
  def new
    @habit = Habit.new
    render inertia: 'Habits/New'
  end

  # GET /habits/1/edit
  def edit
    render inertia: 'Habits/Edit', props: { habit: @habit }
  end

  # POST /habits or /habits.json
  def create
    @habit = Habit.new(habit_params)

    if @habit.save
      redirect_to habits_url, notice: "Habit was successfully created."
    else
      render inertia: 'Habits/New', props: { habit: @habit, errors: @habit.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /habits/1 or /habits/1.json
  def update
    if @habit.update(habit_params)
      redirect_to habit_url(@habit), notice: "Habit was successfully updated.", status: :see_other
    else
      render inertia: 'Habits/Edit', props: { habit: @habit, errors: @habit.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /habits/1 or /habits/1.json
  def destroy
    @habit.destroy!

    redirect_to habits_url, notice: "Habit was successfully deleted.", status: :see_other
  end

  # PATCH /habits/1/complete
  def complete
    if @habit.mark_completed_today!
      redirect_to habits_path, notice: "#{@habit.title} marked as complete for today!"
    else
      redirect_to habits_path, alert: "#{@habit.title} is already completed for today."
    end
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  # PATCH /habits/1/uncomplete
  def uncomplete
    if @habit.unmark_completed_today!
      redirect_to habits_path, notice: "#{@habit.title} marked as incomplete for today."
    else
      redirect_to habits_path, alert: "#{@habit.title} was not completed today."
    end
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_habit
    @habit = Habit.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    head :not_found
    return
  end

  # Only allow a list of trusted parameters through.
  def habit_params
    params.require(:habit).permit(:title, :description)
  end

  def habit_with_completion_status(habit)
    {
      id: habit.id,
      title: habit.title,
      description: habit.description,
      completed_today: habit.completed_today?,
      current_streak: habit.current_streak,
      longest_streak: habit.longest_streak,
      total_completions: habit.total_completions,
      created_at: habit.created_at,
      updated_at: habit.updated_at
    }
  end
end
