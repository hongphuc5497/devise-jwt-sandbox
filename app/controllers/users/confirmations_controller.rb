# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  protect_from_forgery  # if there is no this line, request doesn't recognize properly. (Unprocessable entity)
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  def create
    # super
    logger.debug(Settings.url.fe.root)
    begin
      user = User.find_by(:email => params[:email])
      if user == nil
        redirect_to Settings.url.fe.root + Settings.url.fe.login
      else
        user.send_confirmation_instructions
        render json: {messages: ["The email for confirmation has been resent. Please check the email sent to complete the sign up."]}, status: :ok
      end
    rescue => e
      logger.warn(e.message)
      redirect_to Settings.url.fe.root + Settings.url.fe.login
    end
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    # super
    begin
      user = User.find_by(:confirmation_token => params[:confirmation_token])
      if user == nil
        redirect_to Settings.url.fe.root + Settings.url.fe.login
      elsif user.confirmed_at == nil
        super
      else
        redirect_to Settings.url.fe.root + Settings.url.fe.login
      end
    rescue => e
      redirect_to Settings.url.fe.root + Settings.url.fe.login
    end
  end

  # protected

  # The path used after resending confirmation instructions.
  def after_resending_confirmation_instructions_path_for(resource_name)
    # super(resource_name)
    # move to sign in page by frontend
    return
  end

  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    # super(resource_name, resource)
    Settings.url.fe.root + Settings.url.fe.login
  end
end
