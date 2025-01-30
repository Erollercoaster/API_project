class Api::V1::TasksController < ApplicationController
  before_action :set_user, except: [:index]
  before_action :set_task, only: %i[show update destroy]

  def index
    @tasks = params[:user_id] ? User.find(params[:user_id]).tasks : Task.all
    render json: { notice: 'Tasks fetched successfully', data: @tasks }

  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  end

  def show
    render json: { notice: 'Task found successfully', data: @task }
  end

  def create
    @task = @user.tasks.build(task_params)

    if @task.save
      render json: { notice: 'Task created successfully', data: @task }, status: :created
    else
      render json: { error: 'Failed to create task', details: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      render json: { notice: 'Task updated successfully', data: @task }
    else
      render json: { error: 'Failed to update task', details: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    render json: { notice: 'Task deleted successfully' }, status: :no_content

  rescue ActiveRecord::InvalidForeignKey => e
    render json: { error: "Cannot delete task due to associated records: #{e.message}" }, status: :unprocessable_entity
  end

  private

  def set_user
    @user = User.find(params[:user_id])

  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  end

  def set_task
    @task = @user.tasks.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Task not found' }, status: :not_found
  end

  def task_params
    params.require(:task).permit(:name, :due_date, :description)
  end
end
