# coding: utf-8

class Admin::MediaController < Admin::ApplicationController

  def index
    @media = Medium.all

    respond_to do |format|
      format.html { render }
      format.json do
        render json: @media.map { |m| m.to_jq_upload }
      end
    end
  end

  def new
    @medium = Medium.new

    respond_to do |format|
      format.html { render }
      format.json { render json: @medium }
    end
  end

  def edit
    @medium = Medium.find params[:id]

    respond_to do |format|
      format.html { render }
      format.json { render json: @medium }
    end
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
        format.html do
          flash.now[:alert] = 'Failed!'
          render :new
        end
        format.json do
          render json: @medium.errors, status: :unprocessable_entity
        end
      end
    end
  end

  def update
    @medium = Medium.find params[:id]

    respond_to do |format|
      if @medium.update_attributes params[:medium]
        format.html do
          redirect_to edit_admin_medium_path(@medium), notice: 'Updated!'
          end
          format.json { head :no_content }
      else
        format.htl do
          flash.now[:alert] = 'Failed!'
          render :edit
        end
        format.json do
          render json: @medium.upload_errors, status: :unprocessable_entity
        end
      end
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
