
class Admin::PagesController < Admin::ApplicationController

  def index
    @pages = Page.order 'created_at DESC'
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new params[:page]

    if @page.save
      render :edit
    else
      render :new
    end
  end

  def edit
    @page = Page.find params[:id]
  end

  def update
    @page = Page.find params[:id]

    if @page.update_attributes params[:page]
      render :edit
    end
  end

  def destroy
    @page = Page.find params[:id]
    @page.destroy

    redirect_to admin_pages_path
  end

end
