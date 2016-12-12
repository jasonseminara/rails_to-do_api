class TasksController < ApplicationController

  def index
    render json: Task.all
  end

  def create
    task = Task.create(permitted_params)
  end

  def show
    render json: Task.find_by_id(params[:id])
  end

  def update
    task = Task.find_by_id(params[:id])
    task.update(permitted_params)
  end

  def destroy
    Task.find_by_id(params[:id]).delete
  end

  def toggle
    task = Task.find_by_id(params[:id])
    task[params[:field]] = !task[params[:field]]
    task.save

  end

  private

  def permitted_params
    params.require(:task).permit(:name, :description)
  end

end
