class Api::V1::AuthController < ApplicationController
  protect_from_forgery
  before_action :authenticate_request!, :except => [
      :is_logging_in
  ]

  def is_logging_in
    render json: {messages: []}, status: :ok
  end

  def has_role
    if params['role_name'] == nil
      render json: {errors: ['Invalid parameter']}, status: :bad_request
      return
    end

    if current_user == nil
      render json: {errors: ['Not authenticated']}, status: :unauthorized
      return
    end

    has_result = current_user.has_role? params['role_name']
    if has_result == false
      render json: {errors: ["Login user has no role : #{params['role_name']}"]}, status: :forbidden
      return
    end
    render json: {errors: ['']}, status: :ok
  end
end
