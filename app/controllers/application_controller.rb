class ApplicationController < ActionController::Base
  include InertiaRails::Controller

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Inertia handles CSRF protection
  before_action :set_inertia_csrf_token

  # Share data that will be available to all pages
  inertia_share flash: -> { flash.to_hash }

  # Handle record not found errors
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def set_inertia_csrf_token
    cookies['XSRF-TOKEN'] = form_authenticity_token
  end

  def render_not_found
    render file: "#{Rails.root}/public/404.html", status: :not_found, layout: false
  end
end
