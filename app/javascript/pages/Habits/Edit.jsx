import React from 'react'
import { Link, useForm } from '@inertiajs/react'

export default function Edit({ habit, errors }) {
  const { data, setData, patch, processing } = useForm({
    title: habit?.title || '',
    description: habit?.description || ''
  })

  const handleSubmit = (e) => {
    e.preventDefault()
    patch(`/habits/${habit.id}`)
  }

  return (
    <div className="min-h-screen bg-gray-50 py-8">
      <div className="max-w-2xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="mb-8">
          <div className="flex items-center space-x-4 mb-4">
            <Link
              href={`/habits/${habit.id}`}
              className="text-indigo-600 hover:text-indigo-500"
            >
              ← Back to Habit
            </Link>
          </div>
          <h1 className="text-3xl font-bold text-gray-900">Edit Habit</h1>
          <p className="text-lg text-gray-600 mt-2">Update your habit details</p>
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
                href={`/habits/${habit.id}`}
                className="px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
              >
                Cancel
              </Link>
              <button
                type="submit"
                disabled={processing}
                className="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-50"
              >
                {processing ? 'Updating...' : 'Update Habit'}
              </button>
            </div>
          </form>
        </div>

        {/* Creation Info */}
        <div className="mt-6 bg-gray-50 border border-gray-200 rounded-md p-4">
          <div className="text-sm text-gray-600">
            <p>Created on {new Date(habit.created_at).toLocaleDateString()}</p>
            {habit.updated_at !== habit.created_at && (
              <p>Last updated on {new Date(habit.updated_at).toLocaleDateString()}</p>
            )}
          </div>
        </div>
      </div>
    </div>
  )
}
