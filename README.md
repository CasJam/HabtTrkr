# habttrackr-v2
A habit tracking application built with Test-Driven Development

## Getting Started

This is a Ruby on Rails application for tracking daily habits.

### Prerequisites

* Ruby version: 3.x
* Rails 7.x
* SQLite3 (for development)

### Setup

1. Clone the repository
2. Run `bundle install` to install dependencies
3. Run `rails db:create db:migrate` to set up the database
4. Run `rails server` to start the development server

### Running Tests

This project follows Test-Driven Development (TDD) practices:

```bash
# Run all tests
rails test

# Run specific test files
rails test test/models/
rails test test/controllers/
rails test test/system/
```

### Development Workflow

1. Check `tasks.md` for the next task
2. Write tests first (TDD approach)
3. Implement the minimum code to make tests pass
4. Refactor while keeping tests green
5. Mark task as complete in `tasks.md`
