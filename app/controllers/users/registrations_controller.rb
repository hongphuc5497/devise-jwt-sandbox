# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  protect_from_forgery  # if there is no this line, request doesn't recognize properly. (Unprocessable entity)
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    user = User.find_for_database_authentication(email: params[:email])
    begin
      if user != nil
        # send success message for security reason
        render json: {messages: ["Your sign up request has been accepted. Please check the email sent to complete the sign up."]}, status: :ok
        return
      end
      if params[:password] != params[:password_confirmation]
        render json: {errors: ["Confirm password does not match."]}, status: :bad_request
        return
      end

      user = User.new(:email => params[:email], :password => params[:password], :password_confirmation => params[:password_confirmation])
      user.save
      user.add_role("user")
      render json: {messages: ["Your sign up request has been accepted. Please check the email sent to complete the sign up."]}, status: :ok
      return
    rescue
      render json: {errors: ["Failed to create user."]}, status: :internal_server_error
      return
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
