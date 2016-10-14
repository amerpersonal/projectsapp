class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :change_status, :change_priority]
  before_action :check_permissions, :only => [:edit, :update, :destroy, :new]
  before_action :authenticate_user!, :only => [:change_status, :change_priority]

  before_action :authenticate_user!

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
    
    if @task.expired?
      flash[:task_errors] = {}
      flash[:task_errors][@task.id.to_s] = []
      flash[:task_errors][@task.id.to_s] << "Status cannot be changed for expired task"
    else
      @task.change_status
      @task.save
    end

    redirect_path = request.referer.include?("/tasks/") ? task_path(@task) : project_path(@task.project)
    redirect_to(redirect_path)
  end

  def change_priority
    if @task.expired? || @task.text_status == "Resolved" || @task.text_status == "Closed"
      flash[:task_errors] = {}
      flash[:task_errors][@task.id.to_s] = []
      flash[:task_errors][@task.id.to_s] << "Priority cannot be changed for expired, closed or resolved task"
    else
      @task.priority = params[:priority].to_i rescue nil
      @task.save
    end

    redirect_path = request.referer.include?("/tasks/") ? task_path(@task) : project_path(@task.project)
    redirect_to(redirect_path)
  end

  def edit

  end

  def create
    @task = Task.new(task_params)
    deadline = task_params[:deadline].to_i rescue 1
    @task.deadline = deadline.hours.from_now
    @task.priority = Task::PRIORITIES.first unless Task::PRIORITIES.include?(@task.priority.to_i)    
    @task.status = Task::STATUSES.first.last

    @task.save
    
    unless @task.valid?
      flash[:task] = @task.attributes
      flash[:error] = @task.errors.messages.values.flatten
    end

    redirect_to(project_path(@task.project))
  end

  def update
    task_args = task_params
    unless params[:task_deadline_hours].first.blank?
      deadline = params[:task_deadline_hours].clone.first.to_i rescue 1

      new_deadline = deadline.hours.from_now
      task_args["deadline(1i)"] = new_deadline.year.to_s
      task_args["deadline(2i)"] = new_deadline.month.to_s
      task_args["deadline(3i)"] = new_deadline.day.to_s
      task_args["deadline(4i)"] = new_deadline.hour.to_s
      task_args["deadline(5i)"] = new_deadline.min.to_s
    end

    @task.update(task_args)

    @task.valid? ? flash[:message] = "Task updated" : flash[:error] = @task.errors.messages.values.flatten
    redirect_to edit_task_path(@task.id)
  end

  def destroy
    @task.destroy
    redirect_to(project_path(@task.project_id))
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

    def check_permissions
      redirect_to(project_path(@task.project)) unless user_signed_in? && current_user.projects.include?(@task.project)
    end
end
