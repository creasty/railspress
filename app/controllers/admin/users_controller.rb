# coding: utf-8

class Admin::UsersController < Admin::ApplicationController

  def index
    respond_to do |format|
      format.json do
        if params[:id]
          @user = User.find params[:id]
          render json: @user.to_json
        else
          @users = User
            .sort(params[:sort_by], params[:order])
            .search(params[:search])
            .page(params[:page])
            .per(params[:per_page])

          render json: [
            {
              total_entries: @users.total_count,
              total_pages: @users.total_pages
            },
            @users.map { |user| user.to_json }
          ]
        end
      end
      format.html { render }
    end
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find params[:id]
  end

  def create
    @user = User.new params[:user]

    respond_to do |format|
      if @user.save
        format.json { render json: @user.to_json }
        format.html do
          redirect_to edit_admin_post_path(@user),
            notice: '作成されました'
        end
      else
        format.json do
          render json: @user.errors.full_messages,
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
    @user = User.find params[:id]

    params[:user].delete_if { |_, v| v.blank? }

    @user.attributes = params[:user]

    respond_to do |format|
      if @user.save
        format.json { render json: @user.to_json }
      else
        format.json do
          render json: @user.errors.full_messages,
            status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    @user = User.find params[:id]
    @user.destroy

    respond_to do |format|
      format.json do
        render json: {}
      end

      format.html do
        redirect_to admin_users_path,
          notice: 'ユーザを削除しました'
      end
    end
  end

end
