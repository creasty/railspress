# coding: utf-8

class Admin::PostsController < Admin::ApplicationController

  def index
    @posts = Post
      .order('created_at DESC')
      .page(params[:page])
      .per(params[:per_page])
      .includes(:user)

    @posts = @posts.where get_search_where

    respond_to do |format|
      format.json do
        if params[:only_table]
          params.delete :only_table
          render json: {
            pager: view_context.paginate(
              @posts,
              window: 4,
              outer_window: 2,
              theme: 'admin_table'
            ),
            html: render_to_string(
              partial: 'table_tbody',
              layout: false
            )
          }
        end
      end
      format.html { render }
    end

  end

  def search

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
        format.json do
          render json: {
            success: true,
            msg: '作成されました',
            url: edit_admin_post_path(@post)
          }
        end
        format.html do
          redirect_to edit_admin_post_path(@post), notice: '作成されました'
        end
      else
        format.json do
          render json: {
            success: false,
            msg: '保存に失敗しました',
            errors: @post.errors.full_messages
          }
        end
        format.html do
          save_current_params
          redirect_to new_admin_post_path, alert: '保存に失敗しました'
        end
      end
    end
  end

  def update
    @post = Post.find params[:id]

    respond_to do |format|
      if @post.update_attributes params[:post]
        format.json do
          render json: {
            success: true,
            msg: '更新されました'
          }
        end
      else
        format.json do
          render json: {
            success: false,
            msg: '保存に失敗しました',
            errors: @post.errors.full_messages
          }
        end
      end
    end

  end

  def destroy
    @post = Post.find params[:id]
    @post.destroy

    respond_to do |format|
      format.json do
        render json: {
          success: true,
          msg: '記事を削除しました',
          id: @post.id
        }
      end

      format.html do
        redirect_to admin_posts_path, notice: '記事を削除しました'
      end
    end
  end

private

  def get_search_where
    where = ['1 = 1']

    if params[:post].try(:[], :user_id).present?
      where[0] << ' and user_id = ?'
      where << params[:post][:user_id]
    end
    if params[:post].try(:[], :title).present?
      where[0] << ' and title like ?'
      where << "%#{params[:post][:title]}%"
    end

    where
  end

end
