class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy]
  before_action :authenticate_user!
  before_action :check_permissions, :only => [:destroy]

  respond_to :html

  def create
    @comment = Comment.new(comment_params)
    
    @comment.user = current_user
    @comment.save

    redirect_to task_path(@comment.task.id)
  end

  def destroy
    @comment.destroy
    
    redirect_to task_path(@comment.task.id)
  end

  private
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:text, :created_at, :updated_at, :task_id, :user_id)
    end

    def check_permissions
      redirect_to task_path(@comment.task.id) unless user_signed_in? && current_user == @comment.task.project.user
    end
end
