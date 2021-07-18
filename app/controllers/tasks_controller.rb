class TasksController < ApplicationController
  before_action :set_task, only: [:show, :update, :destroy]

  # GET /tasks
  def index
    render json: Task.order(updated_at: :asc)
  end

  # GET /tasks/1
  def show
    render json: @task
  end

  # POST /tasks
  def create
    task_params = params.permit(:body)
    task = Task.new(task_params)

    if task.save
      render_task = ActiveModelSerializers::SerializableResource.new(task).serializable_hash
      json = { task: render_task, message: Task.enemy_message }
      render json: json, status: :created
    else
      render json: task.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/1
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

  # DELETE /tasks/1
  def destroy
    @task.destroy!
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end
end
