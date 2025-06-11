import React from 'react'
import { Link, router } from '@inertiajs/react'

export default function Show({ habit, flash }) {
  const handleDelete = () => {
    if (confirm('Are you sure you want to delete this habit? This action cannot be undone.')) {
      router.delete(`/habits/${habit.id}`)
    }
  }

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900 py-8">
      <div className="max-w-2xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="mb-8">
          <div className="flex items-center space-x-4 mb-4">
            <Link
              href="/habits"
              className="text-indigo-600 dark:text-indigo-400 hover:text-indigo-500 dark:hover:text-indigo-300"
            >
              ← Back to Habits
            </Link>
          </div>
        </div>

        {/* Flash Messages */}
        {flash?.notice && (
          <div className="mb-4 bg-green-100 dark:bg-green-900 border border-green-400 dark:border-green-600 text-green-700 dark:text-green-300 px-4 py-3 rounded">
            {flash.notice}
          </div>
        )}

        {/* Habit Details */}
        <div className="bg-white dark:bg-gray-800 shadow rounded-lg p-6">
          {/* Title and Actions */}
          <div className="flex justify-between items-start mb-6">
            <div className="flex-1">
              <h1 className="text-3xl font-bold text-gray-900 dark:text-white mb-2">{habit.title}</h1>
              <p className="text-sm text-gray-500 dark:text-gray-400">
                Created on {new Date(habit.created_at).toLocaleDateString()}
              </p>
            </div>
            <div className="flex space-x-2">
              <Link
                href={`/habits/${habit.id}/edit`}
                className="inline-flex items-center px-3 py-2 border border-gray-300 dark:border-gray-600 text-sm font-medium rounded-md text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 dark:focus:ring-indigo-400"
              >
                Edit
              </Link>
              <button
                onClick={handleDelete}
                className="inline-flex items-center px-3 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-red-600 dark:bg-red-700 hover:bg-red-700 dark:hover:bg-red-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 dark:focus:ring-red-400"
              >
                Delete
              </button>
            </div>
          </div>

          {/* Description */}
          {habit.description && (
            <div className="mb-6">
              <h3 className="text-lg font-medium text-gray-900 dark:text-white mb-2">Description</h3>
              <p className="text-gray-600 dark:text-gray-300 whitespace-pre-wrap">{habit.description}</p>
            </div>
          )}

          {/* Placeholder for future tracking features */}
          <div className="border-t border-gray-200 dark:border-gray-700 pt-6">
            <h3 className="text-lg font-medium text-gray-900 dark:text-white mb-4">Tracking</h3>
            <div className="bg-gray-50 dark:bg-gray-700 rounded-md p-4 text-center">
              <div className="text-gray-400 dark:text-gray-500 mb-2">
                <svg className="mx-auto h-8 w-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                </svg>
              </div>
              <p className="text-sm text-gray-500 dark:text-gray-400">
                Habit tracking features coming soon! You'll be able to mark completion, view streaks, and see your progress here.
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
