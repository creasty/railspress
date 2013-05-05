class CommentsController < ApplicationController

  def create
    @post = Post.find params[:post_id]

    comment_object = params[:comment]
    comment_object[:author_ip] = request.remote_ip

    @comment = @post.comments.new(comment_object)

    if @comment.save
      redirect_to post_path(@post)
    else
      # fail
    end
  end

  def destroy
    @comment = Comment.find params[:id]
    @comment.destroy
    render json: { comment: @comment }
  end

end
