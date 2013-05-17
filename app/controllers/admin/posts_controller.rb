# coding: utf-8

class Admin::PostsController < Admin::ApplicationController

  def index
    @posts = Post
      .order('created_at DESC')
      .page(params[:page])
      .per(params[:per_page])
      .includes(:user)

    @posts = @posts.where get_search_where

    if ajax_request? && params[:only_table]
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

    if @post.save
      redirect_to edit_admin_post_path(@post), notice: '作成されました'
    else
      save_current_params
      redirect_to new_admin_post_path, alert: '保存に失敗しました'
    end
  end

  def update
    @post = Post.find params[:id]

    if @post.update_attributes params[:post]
      render json: {
        success: true,
        msg: '更新されました'
      }
    else
      render json: {
        success: false,
        msg: '保存に失敗しました',
        errors: @post.errors.full_messages
      }
    end
  end

  def destroy
    @post = Post.find params[:id]
    @post.destroy

    if ajax_request?
      render json: {
        success: true,
        msg: '記事を削除しました',
        id: @post.id
      }
    else
      redirect_to admin_posts_path
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
