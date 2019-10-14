class Api::V1::UserRoleController < ApplicationController
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
      render json: {message: ["Success"], data: Role.all}, status: :ok
    rescue => e
      logger.error("[EXCEPTION] UserRoleController::index : #{e.message}")
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
      render json: {message: ["Success"], data: user.roles}, status: :ok
      rescue => e
        logger.error("[EXCEPTION] UserRoleController::show : #{e.message}")
        render json: {errors: ["Unknown error"]}, status: :internal_server_error
    end
  end

  def update
    logger.debug(params[:id])
    logger.debug(params[:user_role])

    begin
      has_role = current_user.has_role? 'admin'
      if has_role == false
        render json: {errors: ["No access rights : 'admin'"]}, status: :forbidden
        return
      end
      user = User.find_by(:id => params[:id])
      if user == nil
        render json: {errors: ["No such user"]}, status: :bad_request
        return
      end
      # add roles
      new_roles = params[:user_role]['_json'] # why _json ?
      new_roles.each do |user_role|
        has_role = user.has_role? user_role
        if has_role == false
          user.add_role user_role
        end
      end
      # reduce roles
      user_roles = user.roles
      user_roles.each do |user_role|
        founds = new_roles.select do |role|
          role === user_role.name
        end
        if founds.length < 1
          user.remove_role(user_role.name)
        end
      end
      render json: {message: ["Success"], data: user.roles}, status: :ok
    rescue => e
      logger.error("[EXCEPTION] UserRoleController::show : #{e.message}")
      render json: {errors: ["Unknown error"]}, status: :internal_server_error
    end
  end

  def destroy
    render json: {errors: ["Not implemented"]}, status: :bad_request
  end
end
