class TasksController < ApplicationController
  before_action :check_header, :authenticate_request!
  before_action :getTask, only: [:show, :update, :destroy, :toggle]

  def index
    render json: @current_user.tasks
  end

  def create
    @current_user.tasks << Task.new(permitted_params)
    @current_user.save
  end

  def show
    render json: @task
  end

  def update
    @task.update permitted_params
    head :no_content
  end

  def destroy
    @task.delete
    head :no_content
  end

  def toggle
    head :bad_request unless validField?
    @task[params[:field]] = !@task[params[:field]]
    @task.save
    head :no_content
  end

  private

  # we'll be super strict here and throw a 404 if we can't find a resource.
  def getTask
    @task = @current_user.tasks.find_by_id(params[:id])
    head 404 and return unless @task
  end

  def permitted_params
    params.require(:task).permit(:name, :description)
  end

  def validField?
    params.include?(:field) && :field.to_s === 'field' && ['completed','deleted'].include?(params[:field])
  end

end
