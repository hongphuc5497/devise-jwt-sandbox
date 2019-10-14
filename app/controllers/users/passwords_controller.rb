# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  protect_from_forgery  # if there is no this line, request doesn't recognize properly. (Unprocessable entity)

  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  def create
    # user = User.find_by(email: create_params[:email])
    begin
      user = User.find_for_database_authentication(email: params[:email])
      if user == nil
        render json: {messages: ["Your password reset request has been accepted. Please check the email sent to complete the password update."]}, status: :ok
        return
      end
      user.send_reset_password_instructions
      render json: {messages: ["Your password reset request has been accepted. Please check the email sent to complete the password update."]}, status: :ok
      return
    rescue
      render json: {errors: ["Your password reset request has not been accepted."]}, status: :internal_server_error
      return
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  def update
    begin
      _params = update_password_params
      if _params[:password].length < Devise.password_length.min
        render json: {errors: ["Too short password."]}, status: :bad_request
        return
      elsif _params[:password].length > Devise.password_length.max
        render json: {errors: ["Too long password."]}, status: :bad_request
        return
      end
      user = User.reset_password_by_token(_params)
      render json: user, status: :ok
    rescue => e
      logger.error("Password update failed. #{e.message}")
      render json: {errors: ["Password update failed."]}, status: :internal_server_error
      return
    end
  end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  def after_sending_reset_password_instructions_path_for(resource_name)
    super(resource_name)
  end

  private

  def update_password_params
    params.permit(:reset_password_token, :password, :password_confirmation)
  end
end
