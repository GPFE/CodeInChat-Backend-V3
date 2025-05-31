class ApplicationController < ActionController::API
  include Authentication
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection

  # protect_from_forgery with: :exception to-do - enable this and handle it
end
