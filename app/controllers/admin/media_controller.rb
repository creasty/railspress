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

    respond_to do |format|
      if @medium.save
        format.html do
          redirect_to edit_admin_medium_path(@medium), notice: 'Created!'
        end
        format.json do
          render json: {
            files: [@medium.to_jq_upload]
          }, status: :created#, location: [:admin, @medium]
        end
      else
        flash.now[:alert] = 'Failed!'
        format.html { render :new }
      end
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
