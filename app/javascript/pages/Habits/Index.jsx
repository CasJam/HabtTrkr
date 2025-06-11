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
    <div className="min-h-screen bg-gray-50 py-8">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900 mb-4">HabtTrkr!</h1>
          <p className="text-lg text-gray-600 mb-6">Track your daily habits and build consistency</p>

          <Link
            href="/habits/new"
            className="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
          >
            + Create New Habit
          </Link>
        </div>

        {/* 14-Day Overview */}
        {fourteen_day_overview && (
          <div className="mb-8 bg-white shadow rounded-lg p-6">
            <div className="flex items-center justify-between mb-6">
              <h2 className="text-xl font-semibold text-gray-900">14-Day Overview</h2>
              <div className="text-right">
                <div className="text-sm text-gray-600">Current Streak</div>
                <div className="text-2xl font-bold text-indigo-600">
                  {fourteen_day_overview.current_streak} {fourteen_day_overview.current_streak === 1 ? 'day' : 'days'}
                </div>
              </div>
            </div>

                        <div className="flex justify-between gap-1">
              {fourteen_day_overview.dates.map((dayData, index) => (
                <div key={dayData.date} className="text-center flex-1">
                  <div className="text-xs text-gray-500 mb-1">{dayData.day_name}</div>
                  <div
                    className={`
                      w-8 h-8 mx-auto rounded-md flex items-center justify-center text-xs font-medium border
                      ${dayData.habits_completed > 0
                        ? 'bg-green-100 border-green-300 text-green-800'
                        : 'bg-gray-50 border-gray-200 text-gray-400'
                      }
                      ${dayData.is_today ? 'ring-2 ring-indigo-500' : ''}
                    `}
                    title={`${dayData.habits_completed} habits completed`}
                  >
                    {dayData.day_number}
                  </div>
                  {dayData.habits_completed > 0 && (
                    <div className="text-xs text-green-600 mt-1">
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
          <div className="mb-4 bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded">
            {flash.notice}
          </div>
        )}

        {flash?.alert && (
          <div className="mb-4 bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded">
            {flash.alert}
          </div>
        )}

        {/* Habits List */}
        <div className="bg-white shadow rounded-lg">
          {habits && habits.length > 0 ? (
            <div className="divide-y divide-gray-200">
              {habits.map((habit) => (
                <div key={habit.id} className="p-6 hover:bg-gray-50 habit-item">
                  <div className="flex items-start justify-between">
                    <div className="flex-1">
                      <div className="flex items-center mb-2">
                        <h3 className="text-lg font-medium text-gray-900 mr-3">
                          {habit.title}
                        </h3>
                        {habit.completed_today && (
                          <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                            ✓ Completed today
                          </span>
                        )}
                      </div>
                      {habit.description && (
                        <p className="text-gray-600 mb-4">{habit.description}</p>
                      )}

                      {/* Simplified Streak Information */}
                      <div className="mb-4 p-4 bg-gray-50 rounded-lg">
                        <h4 className="font-medium text-gray-900 mb-2">Statistics</h4>
                        <div className="space-y-1 text-sm text-gray-600">
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
                          className="inline-flex items-center px-3 py-1 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                        >
                          Mark Incomplete
                        </button>
                      ) : (
                        <button
                          onClick={() => handleComplete(habit.id)}
                          className="inline-flex items-center px-3 py-1 border border-green-300 text-sm font-medium rounded-md text-green-700 bg-green-50 hover:bg-green-100 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500"
                        >
                          Mark Complete
                        </button>
                      )}

                      {/* Action Buttons */}
                      <div className="flex space-x-2">
                        <Link
                          href={`/habits/${habit.id}`}
                          className="inline-flex items-center px-3 py-1 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                        >
                          View
                        </Link>
                        <Link
                          href={`/habits/${habit.id}/edit`}
                          className="inline-flex items-center px-3 py-1 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                        >
                          Edit
                        </Link>
                        <button
                          onClick={() => handleDelete(habit.id, habit.title)}
                          className="inline-flex items-center px-3 py-1 border border-red-300 text-sm font-medium rounded-md text-red-700 bg-red-50 hover:bg-red-100 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500"
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
              <div className="mx-auto h-12 w-12 text-gray-400 mb-4">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5H7a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                </svg>
              </div>
              <h3 className="text-lg font-medium text-gray-900 mb-2">No habits yet</h3>
              <p className="text-gray-600 mb-4">Get started by creating your first habit to track.</p>
              <Link
                href="/habits/new"
                className="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700"
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
