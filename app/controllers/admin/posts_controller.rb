# coding: utf-8

class Admin::PostsController < Admin::ApplicationController

  def index
    @posts = Post
      .order('created_at DESC')
      .page(params[:page])
      .per(params[:per_page])
      .includes(:user)

    where = ['1 = 1']

    if params[:post].try(:[], :user_id).try(&:present?)
      where[0] << ' and user_id = ?'
      where << params[:post][:user_id]
    end
    if params[:post].try(:[], :title).try(&:present?)
      where[0] << ' and title like ?'
      where << "%#{params[:post][:title]}%"
    end

    @posts = @posts.where where

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

  def thumbnail
    # todo
  end

  def new
    @post = Post.new
    @post.created_at = Time.now
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new params[:post]

    if @post.save
      flash.now[:notice] = '作成されました'
      render :edit
    else
      flash.now[:alert] = '保存に失敗しました'
      render :new
=begin
      render json: {
        success: false,
        msg: '保存に失敗しました',
        errors: @post.errors.full_messages
      }
=end
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

    render json: {
      success: true,
      msg: '記事を削除しました',
      id: @post.id
    }
  end

end
