class Api::V1::UsersController < ApplicationController
  protect_from_forgery
  before_action :authenticate_request!

  def index
    begin
      has_role = current_user.has_role? 'admin'
      has_role ||= current_user.has_role? 'operator'
      if has_role == false
        render json: {errors: ["No access rights : 'admin/operator'"]}, status: :forbidden
        return
      end
      render json: {message: ["Success"], data: User.all}, status: :ok
    rescue => e
      logger.error("[EXCEPTION] UsersController::index : #{e.message}")
      render json: {errors: ["Unknown error"]}, status: :internal_server_error
    end
  end

  def create
    render json: {errors: ["Not implemented"]}, status: :bad_request
  end

  def new
    render json: {errors: ["Not implemented"]}, status: :bad_request
  end

  def edit
    render json: {errors: ["Not implemented"]}, status: :bad_request
  end

  def show
    begin
      user = User.find_by(:id => params[:id])

      if user == nil
        render json: {errors: ["No such user"]}, status: :bad_request
        return
      end
      has_role = current_user.has_role? 'admin'
      has_role ||= current_user.has_role? 'operator'
      has_role ||= current_user.id === user.id
      if has_role == false
        render json: {errors: ["No access rights : #{params['role_name']}"]}, status: :forbidden
        return
      end
      render json: {message: ["Success"], data: user}, status: :ok
    rescue => e
      logger.error("[EXCEPTION] UsersController::show : #{e.message}")
      render json: {errors: ["Unknown error"]}, status: :internal_server_error
    end
  end

  def update
    begin
      user = User.find_by(:id => params[:id])
      if user == nil
        render json: {errors: ["No such user"]}, status: :bad_request
        return
      end
      has_role = current_user.has_role? 'admin'
      has_role ||= current_user.has_role? 'operator'
      has_role ||= current_user.id === user.id
      if has_role == false
        render json: {errors: ["No access rights : #{params['role_name']}"]}, status: :forbidden
        return
      end
      if params[:user] == nil
        render json: {errors: ["No param"]}, status: :bad_request
        return
      end
      # NOTE : Dont update unnecessary params
      user.full_name = params[:full_name]
      user.save
      render json: {message: ["Success"], data: user}, status: :ok
    rescue => e
      logger.error("[EXCEPTION] UsersController::update : #{e.message}")
      render json: {errors: ["Unknown error"]}, status: :internal_server_error
    end
  end

  def destroy
    begin
      has_role = current_user.has_role? 'admin'
      if has_role == false
        render json: {errors: ["No access rights : #{params['role_name']}"]}, status: :forbidden
        return
      end
      user = User.find_by(:id => params[:id])
      if user == nil
        render json: {errors: ["No such user"]}, status: :bad_request
        return
      end
      user.destroy
      render json: {message: ["Success"], data: user}, status: :ok
    rescue => e
      logger.error("[EXCEPTION] UsersController::destroy : #{e.message}")
      render json: {errors: ["Unknown error"]}, status: :internal_server_error
    end
    render json: {errors: ["Not implemented"]}, status: :bad_request
  end
end
