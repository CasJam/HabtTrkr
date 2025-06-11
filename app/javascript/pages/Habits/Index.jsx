import React from 'react'
import { Link, router } from '@inertiajs/react'

export default function Index({ habits, flash, fourteen_day_overview }) {
  const handleComplete = (habitId) => {
    router.patch(`/habits/${habitId}/complete`, {}, {
      preserveScroll: true,
    })
  }

  const handleUncomplete = (habitId) => {
    router.patch(`/habits/${habitId}/uncomplete`, {}, {
      preserveScroll: true,
    })
  }

  const handleDelete = (habitId, habitTitle) => {
    if (confirm(`Are you sure you want to delete "${habitTitle}"? This action cannot be undone.`)) {
      router.delete(`/habits/${habitId}`, {
        preserveScroll: true,
      })
    }
  }

  const formatStreakText = (days) => {
    if (days === 0) return '0 days'
    if (days === 1) return '1 day'
    return `${days} days`
  }

  const formatCompletionsText = (count) => {
    if (count === 0) return '0 completions'
    if (count === 1) return '1 completion'
    return `${count} completions`
  }

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900 py-8">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900 dark:text-white mb-4">HabtTrkr!</h1>
          <p className="text-lg text-gray-600 dark:text-gray-300 mb-6">Track your daily habits and build consistency</p>

          <Link
            href="/habits/new"
            className="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-indigo-600 dark:bg-indigo-700 hover:bg-indigo-700 dark:hover:bg-indigo-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 dark:focus:ring-indigo-400"
          >
            + Create New Habit
          </Link>
        </div>

        {/* 14-Day Overview */}
        {fourteen_day_overview && (
          <div className="mb-8 bg-white dark:bg-gray-800 shadow rounded-lg p-6">
            <div className="flex items-center justify-between mb-6">
              <h2 className="text-xl font-semibold text-gray-900 dark:text-white">14-Day Overview</h2>
              <div className="text-right">
                <div className="text-sm text-gray-600 dark:text-gray-300">Current Streak</div>
                <div className="text-2xl font-bold text-indigo-600 dark:text-indigo-400">
                  {fourteen_day_overview.current_streak} {fourteen_day_overview.current_streak === 1 ? 'day' : 'days'}
                </div>
              </div>
            </div>

                        <div className="flex justify-between gap-1">
              {fourteen_day_overview.dates.map((dayData, index) => (
                <div key={dayData.date} className="text-center flex-1">
                  <div className="text-xs text-gray-500 dark:text-gray-400 mb-1">{dayData.day_name}</div>
                  <div
                    className={`
                      w-8 h-8 mx-auto rounded-md flex items-center justify-center text-xs font-medium border
                      ${dayData.habits_completed > 0
                        ? 'bg-green-100 dark:bg-green-900 border-green-300 dark:border-green-600 text-green-800 dark:text-green-300'
                        : 'bg-gray-50 dark:bg-gray-700 border-gray-200 dark:border-gray-600 text-gray-400 dark:text-gray-500'
                      }
                      ${dayData.is_today ? 'ring-2 ring-indigo-500 dark:ring-indigo-400' : ''}
                    `}
                    title={`${dayData.habits_completed} habits completed`}
                  >
                    {dayData.day_number}
                  </div>
                  {dayData.habits_completed > 0 && (
                    <div className="text-xs text-green-600 dark:text-green-400 mt-1">
                      {dayData.habits_completed} habits completed
                    </div>
                  )}
                </div>
              ))}
            </div>
          </div>
        )}

        {/* Flash Messages */}
        {flash?.notice && (
          <div className="mb-4 bg-green-100 dark:bg-green-900 border border-green-400 dark:border-green-600 text-green-700 dark:text-green-300 px-4 py-3 rounded">
            {flash.notice}
          </div>
        )}

        {flash?.alert && (
          <div className="mb-4 bg-red-100 dark:bg-red-900 border border-red-400 dark:border-red-600 text-red-700 dark:text-red-300 px-4 py-3 rounded">
            {flash.alert}
          </div>
        )}

        {/* Habits List */}
        <div className="bg-white dark:bg-gray-800 shadow rounded-lg">
          {habits && habits.length > 0 ? (
            <div className="divide-y divide-gray-200 dark:divide-gray-700">
              {habits.map((habit) => (
                <div key={habit.id} className="p-6 hover:bg-gray-50 dark:hover:bg-gray-700 habit-item">
                  <div className="flex items-start justify-between">
                    <div className="flex-1">
                      <div className="flex items-center mb-2">
                        <h3 className="text-lg font-medium text-gray-900 dark:text-white mr-3">
                          {habit.title}
                        </h3>
                        {habit.completed_today && (
                          <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 dark:bg-green-900 text-green-800 dark:text-green-300">
                            ✓ Completed today
                          </span>
                        )}
                      </div>
                      {habit.description && (
                        <p className="text-gray-600 dark:text-gray-300 mb-4">{habit.description}</p>
                      )}

                      {/* Simplified Streak Information */}
                      <div className="mb-4 p-4 bg-gray-50 dark:bg-gray-700 rounded-lg">
                        <h4 className="font-medium text-gray-900 dark:text-white mb-2">Statistics</h4>
                        <div className="space-y-1 text-sm text-gray-600 dark:text-gray-300">
                          <div>Current Streak: {formatStreakText(habit.current_streak || 0)}</div>
                          <div>Longest Streak: {formatStreakText(habit.longest_streak || 0)}</div>
                          <div>Total: {formatCompletionsText(habit.total_completions || 0)}</div>
                        </div>
                      </div>
                    </div>
                    <div className="flex flex-col space-y-2 ml-4">
                      {/* Completion Button */}
                      {habit.completed_today ? (
                        <button
                          onClick={() => handleUncomplete(habit.id)}
                          className="inline-flex items-center px-3 py-1 border border-gray-300 dark:border-gray-600 text-sm font-medium rounded-md text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 dark:focus:ring-indigo-400"
                        >
                          Mark Incomplete
                        </button>
                      ) : (
                        <button
                          onClick={() => handleComplete(habit.id)}
                          className="inline-flex items-center px-3 py-1 border border-green-300 dark:border-green-600 text-sm font-medium rounded-md text-green-700 dark:text-green-300 bg-green-50 dark:bg-green-900 hover:bg-green-100 dark:hover:bg-green-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500 dark:focus:ring-green-400"
                        >
                          Mark Complete
                        </button>
                      )}

                      {/* Action Buttons */}
                      <div className="flex space-x-2">
                        <Link
                          href={`/habits/${habit.id}`}
                          className="inline-flex items-center px-3 py-1 border border-gray-300 dark:border-gray-600 text-sm font-medium rounded-md text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 dark:focus:ring-indigo-400"
                        >
                          View
                        </Link>
                        <Link
                          href={`/habits/${habit.id}/edit`}
                          className="inline-flex items-center px-3 py-1 border border-gray-300 dark:border-gray-600 text-sm font-medium rounded-md text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 dark:focus:ring-indigo-400"
                        >
                          Edit
                        </Link>
                        <button
                          onClick={() => handleDelete(habit.id, habit.title)}
                          className="inline-flex items-center px-3 py-1 border border-red-300 dark:border-red-600 text-sm font-medium rounded-md text-red-700 dark:text-red-300 bg-red-50 dark:bg-red-900 hover:bg-red-100 dark:hover:bg-red-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 dark:focus:ring-red-400"
                        >
                          Delete
                        </button>
                      </div>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          ) : (
            <div className="p-12 text-center">
              <div className="mx-auto h-12 w-12 text-gray-400 dark:text-gray-500 mb-4">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5H7a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                </svg>
              </div>
              <h3 className="text-lg font-medium text-gray-900 dark:text-white mb-2">No habits yet</h3>
              <p className="text-gray-600 dark:text-gray-300 mb-4">Get started by creating your first habit to track.</p>
              <Link
                href="/habits/new"
                className="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-indigo-600 dark:bg-indigo-700 hover:bg-indigo-700 dark:hover:bg-indigo-800"
              >
                Create Your First Habit
              </Link>
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
