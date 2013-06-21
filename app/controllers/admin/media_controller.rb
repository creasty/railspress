# coding: utf-8

class Admin::MediaController < Admin::ApplicationController

  def index
    respond_to do |format|
      format.json do
        @media = Medium
          .order('created_at desc')
          .page(params[:page])
          .per(params[:per_page])

        paginate_headers_for @media

        render json: @media.map { |m| m.to_backbone_json }
      end

      format.html { render }
    end
  end

  def new
    @medium = Medium.new

    respond_to do |format|
      format.html { render }
      format.json { render json: @medium.to_backbone_json }
    end
  end

  def edit
    @medium = Medium.find params[:id]

    respond_to do |format|
      format.html { render }
      format.json { render json: @medium.to_backbone_json }
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
          render json: @medium.to_backbone_json
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
          format.json { render json: { message: 'メディアを更新しました' } }
      else
        format.html do
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
        message: 'メディアを削除しました',
        id: @medium.id
      }
    else
      redirect_to admin_media_path, notice: 'Deleted!'
    end
  end

end
