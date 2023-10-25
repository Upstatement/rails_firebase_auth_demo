# frozen_string_literal: true

# Users controller

require 'net/http'
require 'json'
# API Module
module Api
  # Users controller
  class UsersController < ApplicationController
    before_action :authenticate

    # Retrieve user info for the currently authenticated user
    def me
      if @current_user
        render json: @current_user
      else
        render json: { error: 401, message: 'Missing authorization token' }, status: 401
      end
    end

    private

    # Authenticate request with Firebase auth token
    #
    # Note: As written, there is a round-trip to Firebase for every
    # authenticated API request. You could avoid the need for this by:
    #
    # 1. Using Rails sessions to cache the authenticated local user ID
    # 2. Using a stateless, token-based solution (ex: JSON Web Tokens)
    #
    # See also:
    # - https://guides.rubyonrails.org/security.html#sessions
    # - https://www.pluralsight.com/guides/token-based-authentication-with-ruby-on-rails-5-api
    # - https://jwt.io/
    # - https://security.stackexchange.com/a/92123
    def authenticate
      # Check for a bearer token in the `Authorization` HTTP header
      authenticate_with_http_token do |token|
        # Retrieve user details by token from Firebase
        firebase_user = fetch_firebase_user_with_token(token)

        # Find or create an associated local user by Firebase ID
        @current_user = User.find_or_create_by(firebase_uid: firebase_user['localId']) do |user|
          user.email = firebase_user['email']
          user.display_name = firebase_user['displayName']
          user.photo_url = firebase_user['photoUrl']
        end
      rescue RuntimeError => e
        render json: { error: 400, message: e.message }, status: 400
      end
    end

    # Retrieve Firebase user info with auth token
    # https://firebase.google.com/docs/reference/rest/auth#section-get-account-info
    def fetch_firebase_user_with_token(token)
      uri = URI('https://identitytoolkit.googleapis.com/v1/accounts:lookup')
      params = { key: ENV['FIREBASE_WEB_API_KEY'] }
      uri.query = URI.encode_www_form(params)

      req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
      req.body = { 'idToken': token }.to_json

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      res = http.request(req)

      case res
      when Net::HTTPSuccess
        res_json = JSON.parse(res.body)
        res_json['users'].first
      else
        res_json = JSON.parse(res.body) if req.response_body_permitted?
        message = res_json.dig('error', 'message') if res_json
        message ||= 'Unable to verify auth token'
        raise message
      end
    end
  end
end
