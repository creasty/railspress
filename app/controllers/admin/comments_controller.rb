
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
          .includes :post, :user

        paginate_headers_for @threads

        render json: @threads.map { |thread| thread.to_thread_json }
      end
      format.html { render }
    end
  end

  def index
    respond_to do |format|
      format.json do
=begin

  select
    cc.*,
    r2.positive as user_positive,
    r2.negative as user_negative
  from ratings as r2
  right join (
    select
      comments.*,
      sum(r.positive) as total_positives,
      sum(r.negative) as total_negatives
    from comments
    left join ratings as r
    on r.ratable_type = 'Comment'
    and r.ratable_id = comments.id
    where comments.post_id = 42
    group by comments.id
  ) as cc
  on r2.ratable_type = 'Comment'
  and r2.ratable_id = cc.id
  and r2.user_id = 1
  group by cc.id

=end
        @comments = Comment
          .select('
            comments.*,
            sum(r.positive) as like_counts,
            sum(r.negative) as dislike_counts
          ')
          .joins('
            left join ratings as r
            on r.ratable_type = \'Comment\'
            and r.ratable_id = comments.id
          ')
          .where(post_id: params[:post_id])
          .order('comments.created_at DESC')
          .group('comments.id')
          .page(params[:page])
          .per(params[:per_page])
          .includes :post, :user

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
