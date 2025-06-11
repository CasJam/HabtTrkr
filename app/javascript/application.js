import React from 'react'
import { createRoot } from 'react-dom/client'
import { createInertiaApp } from '@inertiajs/react'

// Import pages directly
import Welcome from './pages/Welcome.jsx'
import HabitsIndex from './pages/Habits/Index.jsx'
import HabitsNew from './pages/Habits/New.jsx'
import HabitsShow from './pages/Habits/Show.jsx'
import HabitsEdit from './pages/Habits/Edit.jsx'

const pages = {
  'Welcome': Welcome,
  'Habits/Index': HabitsIndex,
  'Habits/New': HabitsNew,
  'Habits/Show': HabitsShow,
  'Habits/Edit': HabitsEdit,
}

createInertiaApp({
  resolve: name => {
    const page = pages[name]
    if (!page) {
      throw new Error(`Page component "${name}" not found`)
    }
    return page
  },
  setup({ el, App, props }) {
    const root = createRoot(el)
    root.render(<App {...props} />)
  },
})
