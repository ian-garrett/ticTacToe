class UsersController < ApplicationController
  respond_to :json

  def show
    respond_with User.find(params[:id])
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: 201, location: [user]
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def update
    # process the user's credentials
    return render json: { errors: ['not authenticated'] }, status: 403 unless username_and_password?
    user_id = User.authenticate(params[:username], params[:password])
    return render json: { errors: ['not authenticated'] }, status: 403 if user_id.nil?

    # verify the user's access
    user = User.find(params[:id])
    return render json: { errors: ['not permitted'] }, status: 403 unless user.id == user_id

    if user.update(user_params)
      render json: user, status: 200, location: [user]
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def destroy
    # process the user's credentials
    return render json: { errors: ['not authenticated'] }, status: 403 unless username_and_password?
    user_id = User.authenticate(params[:username], params[:password])
    return render json: { errors: ['not authenticated'] }, status: 403 if user_id.nil?

    # verify the user's access
    user = User.find(params[:id])
    return render json: { errors: ['not permitted'] }, status: 403 unless user.id == user_id

    user.destroy
    head 204
  end

  private

  def username_and_password?
    params[:username].present? && params[:password].present?
  end

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
