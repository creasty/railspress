
class Admin::CommentsController < Admin::ApplicationController

  def index
    respond_to do |format|
      format.json do
        @comments = Comment
          .group('post_id')
          .order('created_at DESC')
          .includes :post

        render json: @comments.map { |comment| comment.to_backbone_json }
      end
      format.html { render }
    end
  end

  def show
    respond_to do |format|
      @comment = Comment
        .where('post_id = ?', params[comment][:post_id])
        .order('created_at DESC')
        .includes :post
    end
  end

end
