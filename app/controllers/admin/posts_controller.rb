# coding: utf-8

class Admin::PostsController < Admin::ApplicationController

  def index
    respond_to do |format|
      format.json do
        @posts = Post
          .sort(params[:sort_by], params[:order])
          .search(params[:search])
          .page(params[:page])
          .per(params[:per_page])
          .includes(:user, :thumbnail)

        render json: [
          {
            total_entries: @posts.total_count,
            total_pages: @posts.total_pages
          },
          @posts.map { |post| post.to_backbone_json }
        ]
      end
      format.html { render }
    end

  end

  def new
    @post = Post.new previous_params[:post]
    @post.created_at = Time.now unless previous_params[:post]
  end

  def edit
    @post = Post.find params[:id]
  end

  def create
    @post = Post.new params[:post]

    respond_to do |format|
      if @post.save
        format.json { render json: @post.to_backbone_json }
        format.html do
          redirect_to edit_admin_post_path(@post),
            notice: '作成されました'
        end
      else
        format.json do
          redner json: @post.errors.full_messages,
            status: :unprocessable_entity
        end
        format.html do
          save_current_params
          redirect_to new_admin_post_path,
            alert: '保存に失敗しました'
        end
      end
    end
  end

  def update
    @post = Post.find params[:id]

    respond_to do |format|
      if @post.update_attributes params[:post]
        format.json { render json: @post.to_backbone_json }
      else
        format.json do
          render json: @post.errors.full_messages,
            status: :unprocessable_entity
        end
      end
    end

  end

  def destroy
    @post = Post.find params[:id]
    @post.destroy

    respond_to do |format|
      format.json { render json: @post.to_backbone_json }

      format.html do
        redirect_to admin_posts_path,
          notice: '記事を削除しました'
      end
    end
  end

end
