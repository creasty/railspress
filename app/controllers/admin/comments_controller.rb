
class Admin::CommentsController < Admin::ApplicationController

  def inbox
    respond_to do |format|
      format.json do
        @threads = Comment
          .select('comments.*')
          .joins('
            inner join (
              select post_id, max(created_at) as latest
              from comments
              group by post_id
            ) as cm
            on cm.post_id = comments.post_id
            and cm.latest = comments.created_at
          ')
          .order('created_at DESC')
          .page(params[:page])
          .per(params[:per_page])
          .includes :post

        paginate_headers_for @threads

        render json: @threads.map { |thread| thread.to_thread_json }
      end
      format.html { render }
    end
  end

  def index
    respond_to do |format|
      format.json do
        @comments = Comment
          .where(post_id: params[:post_id])
          .order('created_at DESC')
          .page(params[:page])
          .per(params[:per_page])

        paginate_headers_for @comments

        render json: @comments.map { |comment| comment.to_json }
      end
    end
  end

  def create
    respond_to do |format|
      format.json do
        @comment = Comment.new params[:comment]
        @comment.post_id = params[:post_id]
        @comment.user = current_user

        if @comment.save
          render json: @comment.to_json(true)
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
          render json: @comment.to_json
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
