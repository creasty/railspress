# coding: utf-8

class Admin::MediaController < Admin::ApplicationController

  def index
    @media = Medium.all
  end

  def new
    @medium = Medium.new
  end

  def edit
    @medium = Medium.find params[:id]
  end

  def create
    @medium = Medium.new params[:medium]

    if @medium.save
      redirect_to edit_admin_medium_path(@medium), notice: 'Created!'
    else
      flash.now[:alert] = 'Failed!'
      render :new
    end
  end

  def update
    @medium = Medium.find params[:id]

    if @medium.update_attributes params[:medium]
      redirect_to edit_admin_medium_path(@medium), notice: 'Updated!'
    else
      flash.now[:alert] = 'Failed!'
      render :edit
    end
  end

  def destroy
    @medium = Medium.find params[:id]
    @medium.destroy

    if ajax_request?
      render json: {
        success: true,
        msg: '削除しました',
        id: @medium.id
      }
    else
      redirect_to admin_media_path, notice: 'Deleted!'
    end
  end

end
