class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :change_status, :change_priority]
  before_action :check_permission, :only => [:edit, :update, :destroy, :new, :create]
  before_action :authenticate_user!, :only => [:change_status, :change_priority]

  respond_to :html

  def index
    @tasks = Task.all
    respond_with(@tasks)
  end

  def show
    respond_with(@task)
  end

  def new
    @task = Task.new
    respond_with(@task)
  end

  def change_status
    @task.change_status
    @task.save

    redirect_to(project_path(@task.project))
  end

  def change_priority
    @task.priority = params[:priority]
    @task.save

    redirect_to(project_path(@task.project))
  end

  def edit
  end

  def create
    @task = Task.new(task_params)
    @task.status = Task.statuses.values.first
    @task.save
    # respond_with(@task)

    unless @task.valid?
      flash[:task] = @task.attributes
      flash[:error] = @task.errors.messages.values.flatten
    end

    redirect_to(project_path(@task.project))
  end

  def update
    @task.update(task_params)
    respond_with(@task)
  end

  def destroy
    @task.destroy
    respond_with(@task)
  end

  private
    def set_task
      @task = if params[:id]
        Task.find(params[:id])
      elsif params[:task_id]
        Task.find(params[:task_id])
      else
        nil
      end
    end

    def task_params
      params.require(:task).permit(:title, :description, :status, :deadline, :priority, :created_at, :updated_at, :project_id)
    end

    def check_permission
      redirect_to(show_path(@task.project)) if user_signed_in? && current_user.projects.include?(@task.project)
    end
end
