
class Admin::CommentsController < Admin::ApplicationController

  def inbox
    respond_to do |format|
      format.json do
        @comments = Comment
          .group('post_id')
          .order('created_at DESC')
          .includes :post

        render json: @comments.map { |comment| comment.post.to_backbone_json }
      end
      format.html { render }
    end
  end

  def index
    respond_to do |format|
      format.json do
        @comments = Comment
          .where('post_id = ?', params[:post_id])
          .order('created_at DESC')

        render json: @comments.map { |comment| comment.to_backbone_json }
      end
    end
  end

  def create
    respond_to do |format|
      format.json do
        @comment = Comment.new params[:comment]
        @comment.user = current_user

        if @comment.save
          render json: @comment.to_backbone_json
        else
          render json: @comment.errors.full_messages,
            status: :unprocessable_entity
        end
      end
    end
  end

  def update
    respond_to do |format|
      format.json do
        @comment = Comment.find params[:id]

        if @comment.update_attributes params[:comment]
          render json: @comment.to_backbone_json
        else
          render json: @comment.errors.full_messages,
            status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    @comment = Comment.find params[:id]
    @comment.destroy

    respond_to do |format|
      format.json do
        render json: {}
      end
    end
  end

end
