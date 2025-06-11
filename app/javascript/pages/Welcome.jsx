import React from 'react'

export default function Welcome() {
  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50 dark:bg-gray-900">
      <div className="max-w-md mx-auto text-center">
        <h1 className="text-4xl font-bold text-gray-900 dark:text-white mb-4">
          Welcome to HabtTrkr
        </h1>
        <p className="text-lg text-gray-600 dark:text-gray-300 mb-8">
          Your app is now powered by Inertia.js and React!
        </p>
        <div className="bg-green-100 dark:bg-green-900 border border-green-400 dark:border-green-600 text-green-700 dark:text-green-300 px-4 py-3 rounded">
          ✅ Inertia.js + React is successfully configured
        </div>
      </div>
    </div>
  )
}
