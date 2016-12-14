class TasksController < ApplicationController
  before_action :check_header, :authenticate_request!
  before_action :get_task, only: [:show, :update, :destroy, :toggle]

  def index
    render json: @current_user.tasks
  end

  def create
    newTask = Task.new(permitted_params)
    @current_user.tasks << newTask
    @current_user.save
    head :created, location: newTask
  end

  def show
    render json: @task
  end

  def update
    @task.update permitted_params
    head :no_content, location: @task
  end

  def destroy
    @task.delete
    head :no_content
  end

  def toggle
    head :bad_request unless valid_field?
    @task.toggle! params[:field]
    head :no_content, location: @task
  end

  private

  # we'll be super strict here and throw a 404 if we can't find a resource.
  def get_task
    @task = @current_user.tasks.find(params[:id])
    head 404 and return unless @task
  end

  def permitted_params
    params.require(:task).permit(:name, :description)
  end

  def valid_field?
    params.include?(:field) && :field.to_s === 'field' && ['completed','deleted'].include?(params[:field])
  end

end
