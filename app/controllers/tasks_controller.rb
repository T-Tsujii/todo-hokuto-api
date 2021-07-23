class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:show, :update, :destroy]

  def index
    render json: current_user.tasks.order(updated_at: :asc)
  end

  def show
    render json: @task
  end

  def create
    task_params = params.permit(:body)
    task = current_user.tasks.new(task_params)

    if task.save
      render_task = ActiveModelSerializers::SerializableResource.new(task).serializable_hash
      json = { task: render_task, message: Task.enemy_message }
      render json: json, status: :created
    else
      render json: task.errors, status: :unprocessable_entity
    end
  end

  def update
    is_completed = params[:isCompleted]

    task_params = {
      is_completed: is_completed,
      completed_at: is_completed ? Time.current : nil
    }

    if is_completed != @task.is_completed && @task.update(task_params)
      render json: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy!
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end
end
