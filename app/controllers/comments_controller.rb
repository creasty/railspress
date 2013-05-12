class CommentsController < ApplicationController

  def create
    @post = Post.find params[:post_id]
    params[:comment][:user_id] = current_user.id
    @comment = @post.comments.new params[:comment]

    if @comment.save
      redirect_to post_path(@post)
    else
      # fail
    end
  end

  def destroy
    @comment = Comment.find params[:id]

    return unless is_current_user?(@comment.user_id) || is_admin?

    @comment.destroy
    render json: { comment: @comment }
  end

end
