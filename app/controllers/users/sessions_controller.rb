# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  protect_from_forgery  # if there is no this line, request doesn't recognize properly. (Unprocessable entity)

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    begin
      user = User.find_for_database_authentication(email: params[:email])
      if user == nil
        render json: {errors: ["Invalid Username/Password."]}, status: :unauthorized
      else
        if user.valid_password?(params[:password])
          if !user.confirmed?
            render json: {errors: ["Not confirmed yet. Please check if a confirmation email has arrived."]}, status: :unauthorized
          else
            render json: payload(user)
          end
        else
          render json: {errors: ["Invalid Username/Password."]}, status: :unauthorized
        end
      end
    rescue => e
      render json: {errors: ["Failed to login."]}, status: :internal_server_error
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private

  def payload(user)
    return nil unless user and user.id
    {
        auth_token: JsonWebToken.encode({user_id: user.id, exp: (Time.now + 2.week).to_i}),
        user: {id: user.id, email: user.email}
    }
  end
end
