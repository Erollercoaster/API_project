class Api::V1::RemarksController < ApplicationController
  before_action :set_user, only: [:create, :update, :destroy, :show]
  before_action :set_task, only: [:create, :update, :destroy, :show]
  before_action :set_remark, only: [:show, :update, :destroy]

  def index
    if params[:task_id].present? && params[:user_id].present?
      @remarks = Remark.joins(:task).where(tasks: { id: params[:task_id] }, user_id: params[:user_id])
      render json: { notice: 'Remarks fetched successfully', data: @remarks }
    else
      @remarks = Remark.all
      render json: { notice: 'All remarks fetched successfully', data: @remarks }
    end

  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def show
    render json: { notice: 'Remark found successfully', data: @remark }

  rescue ActiveRecord::RecordNotFound => e
    render json: { error: 'Remark not found' }, status: :not_found
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def create
    @remark = @task.remarks.build(remark_params)
    @remark.user = @user

    if @remark.save
      render json: { notice: 'Remark created successfully', data: @remark }, status: :created
    else
      render json: { error: 'Failed to create remark', details: @remark.errors.full_messages }, status: :unprocessable_entity
    end

  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def update
    if @remark.update(remark_params)
      render json: { notice: 'Remark updated successfully', data: @remark }
    else
      render json: { error: 'Failed to update remark', details: @remark.errors.full_messages }, status: :unprocessable_entity
    end

  rescue ActiveRecord::RecordNotFound => e
    render json: { error: 'Remark not found' }, status: :not_found
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def destroy
    @remark.destroy
    render json: { notice: 'Remark deleted successfully' }, status: :no_content

  rescue ActiveRecord::RecordNotFound => e
    render json: { error: 'Remark not found' }, status: :not_found
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def set_user
    @user = User.find(params[:user_id])

  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  end

  def set_task
    @task = @user.tasks.find(params[:task_id])

  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Task not found' }, status: :not_found
  end

  def set_remark
    @remark = @task.remarks.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Remark not found' }, status: :not_found
  end

  def remark_params
    params.require(:remark).permit(:content)
  end
end
