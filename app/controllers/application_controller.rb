class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :authenticate_user!
  # before_action :authenticate, if: -> { Rails.env.production? }

  # protected

  # def authenticate
  #   authenticate_or_request_with_http_token do |token, _options|
  #     token == Rails.application.credentials.token
  #   end
  # end
end
