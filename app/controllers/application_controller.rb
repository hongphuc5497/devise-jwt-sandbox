class ApplicationController < ActionController::Base
  # <<<
  # 認証TOKENを仕込む処理
  # NOTE : APIからのPOSTを受ける際にリクエストヘッダーに仕込まれていないと認証エラーとなる
  # <<<
  protect_from_forgery with: :exception
  # protect_from_forgery

  after_action :set_csrf_cookie

  def set_csrf_cookie
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  # >>> 認証TOKENを仕込む処理 ここまで
  protected

  def authenticate_request!
    unless user_id_in_token?
      # render json: { errors: ['Not Authenticated'] }, status: :unauthorized
      render json: {errors: ['Not authenticated']}, status: :unauthorized
      return
    end
    # START : ===== debug for token authenticate (to fail)
    # render json: {errors: ['Not authenticated']}, status: :unauthorized
    # return
    # END : ===== debug for token authenticate (to fail)
    @current_user = User.find(auth_token[:user_id])
  rescue JWT::VerificationError, JWT::DecodeError
    logger.warn("ApplicationController::authenticate_request! : Invalid authentication data.")
    render json: {errors: ['Invalid authentication data.']}, status: :unauthorized
  rescue => e
    logger.warn("ApplicationController::authenticate_request! : Unknown error occurred [#{e.message}]")
    render json: {errors: ['Sorry. Unknown error occurred.']}, status: :internal_server_error
  end

  private

  def http_token
    @http_token ||= if request.headers['Authorization'].present?
                      request.headers['Authorization'].split(' ').last
                    end
  end

  def auth_token
    @auth_token ||= JsonWebToken.decode(http_token)
  end

  def user_id_in_token?
    http_token && auth_token && auth_token[:user_id].to_i
  end
end

