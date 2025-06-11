class PagesController < ApplicationController
  def welcome
    render inertia: 'Welcome'
  end
end
