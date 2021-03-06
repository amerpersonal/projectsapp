class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_user!
  before_action :check_permissions, :only => [:edit, :update, :destroy]

  respond_to :html

  def index
    @projects = params[:category] ? Project.where(category: params[:category]).order(updated_at: :desc) : Project.all.order(updated_at: :desc)
    
    respond_with(@projects)
  end

  def show
    respond_with(@project)
  end

  def new
    @project = Project.new
    respond_with(@project)
  end

  def edit
  end

  def create
    @project = Project.new(project_params)
    @project.user = current_user
    @project.created_at = DateTime.now
    @project.updated_at = DateTime.now

    @project.save

    unless @project.valid?
      flash[:error] = @project.errors.messages.values.flatten
      flash[:project] = @project.attributes
    end

    redirect_to(action: "index")
  end

  def update
    @project.update(project_params)

    flash[:error] = @project.errors.messages.values.flatten unless @project.valid?
    redirect_to edit_project_path(@project)
  end

  def destroy
    @project.destroy
    redirect_to(action: "index")
  end

  private
    def set_project
      @project = Project.find(params[:id])
    end

    def project_params
      params.require(:project).permit(:title, :description, :category)
    end

    def check_permissions
      user_signed_in? && @project.user_id == current_user.id
    end
end
