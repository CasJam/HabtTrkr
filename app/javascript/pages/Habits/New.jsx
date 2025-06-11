import React, { useState } from 'react'
import { Link, useForm } from '@inertiajs/react'

export default function New({ habit, errors }) {
  const { data, setData, post, processing } = useForm({
    title: habit?.title || '',
    description: habit?.description || ''
  })

  const handleSubmit = (e) => {
    e.preventDefault()
    post('/habits')
  }

  return (
    <div className="min-h-screen bg-gray-50 py-8">
      <div className="max-w-2xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="mb-8">
          <div className="flex items-center space-x-4 mb-4">
            <Link
              href="/habits"
              className="text-indigo-600 hover:text-indigo-500"
            >
              ← Back to Habits
            </Link>
          </div>
          <h1 className="text-3xl font-bold text-gray-900">Create New Habit</h1>
          <p className="text-lg text-gray-600 mt-2">Start tracking a new habit today</p>
        </div>

        {/* Form */}
        <div className="bg-white shadow rounded-lg p-6">
          <form onSubmit={handleSubmit}>
            {/* Title Field */}
            <div className="mb-6">
              <label htmlFor="title" className="block text-sm font-medium text-gray-700 mb-2">
                Habit Title *
              </label>
              <input
                type="text"
                id="title"
                name="title"
                value={data.title}
                onChange={(e) => setData('title', e.target.value)}
                className={`block w-full px-3 py-2 rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm ${
                  errors?.title ? 'border-red-300 focus:border-red-500 focus:ring-red-500' : ''
                }`}
                placeholder="e.g., Drink 8 glasses of water"
                autoFocus
                required
              />
              {errors?.title && (
                <p className="mt-2 text-sm text-red-600">{errors.title[0]}</p>
              )}
            </div>

            {/* Description Field */}
            <div className="mb-6">
              <label htmlFor="description" className="block text-sm font-medium text-gray-700 mb-2">
                Description (Optional)
              </label>
              <textarea
                id="description"
                name="description"
                rows={4}
                value={data.description}
                onChange={(e) => setData('description', e.target.value)}
                className={`block w-full px-3 py-2 rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm ${
                  errors?.description ? 'border-red-300 focus:border-red-500 focus:ring-red-500' : ''
                }`}
                placeholder="Describe your habit, why it's important to you, or any additional details..."
              />
              {errors?.description && (
                <p className="mt-2 text-sm text-red-600">{errors.description[0]}</p>
              )}
            </div>

            {/* Form Actions */}
            <div className="flex justify-end space-x-4">
              <Link
                href="/habits"
                className="px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
              >
                Cancel
              </Link>
              <button
                type="submit"
                disabled={processing}
                className="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-50"
              >
                {processing ? 'Creating...' : 'Create Habit'}
              </button>
            </div>
          </form>
        </div>

        {/* Help Text */}
        <div className="mt-6 bg-blue-50 border border-blue-200 rounded-md p-4">
          <div className="flex">
            <div className="flex-shrink-0">
              <svg className="h-5 w-5 text-blue-400" fill="currentColor" viewBox="0 0 20 20">
                <path fillRule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clipRule="evenodd" />
              </svg>
            </div>
            <div className="ml-3">
              <h3 className="text-sm font-medium text-blue-800">Tips for creating effective habits</h3>
              <div className="mt-2 text-sm text-blue-700">
                <ul className="list-disc pl-5 space-y-1">
                  <li>Make it specific and measurable</li>
                  <li>Start small and build up gradually</li>
                  <li>Focus on consistency over perfection</li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
