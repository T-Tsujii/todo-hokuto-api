class TasksController < ApplicationController
  before_action :set_task, only: [:show, :update, :destroy]

  # GET /tasks
  def index
    tasks = Task.order(updated_at: :asc).select(:id, :body, :is_completed).map { |task| task.attributes.transform_keys { |k| k.camelize(:lower) } }

    render json: tasks
  end

  # GET /tasks/1
  def show
    render json: @task.attribute_slice
  end

  # POST /tasks
  def create
    task_params = params.permit(:body)
    task = Task.new(task_params)

    if task.save
      json = { task: task.attribute_slice, message: Task.enemy_message }
      render json: json, status: :created, location: task
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
      render json: @task.attribute_slice
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end
end
