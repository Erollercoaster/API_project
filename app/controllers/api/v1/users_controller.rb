class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]

  def index
    @users = User.all
    render json: { notice: 'Users fetched successfully', data: @users }
  end

  def show
    render json: { notice: 'User found successfully', data: @user }
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: { notice: 'User created successfully', data: @user }, status: :created
    else
      render json: { error: 'Failed to create user', details: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: { notice: 'User updated successfully', data: @user }
    else
      render json: { error: 'Failed to update user', details: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    render json: { notice: 'User deleted successfully' }, status: :no_content

  rescue ActiveRecord::InvalidForeignKey => e
    render json: { error: "Cannot delete user with associated tasks: #{e.message}" }, status: :unprocessable_entity
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone_number)
  end
end
