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
      flash.now[:notice] = 'Created!'
      render :edit
    else
      flash.now[:alert] = 'Failed!'
      render :new
    end
  end

  def update
    @medium = Medium.find params[:id]

    if @medium.update_attributes params[:meduim]
      flash.now[:notice] = 'Updated!'
    else
      flash.now[:alert] = 'Failed!'
    end

    render :edit
  end

  def destroy
    @medium = Medium.find params[:id]
    @medium.destroy

    render :index
  end

end
