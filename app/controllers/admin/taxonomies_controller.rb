
class Admin::TaxonomiesController < Admin::ApplicationController

  def index
    @taxonomies = Taxonomy.includes(:terms).all
  end

  def new
    @taxonomy = Taxonomy.new
  end

  def edit
    @taxonomy = Taxonomy.find params[:id]
  end

  def create
    @taxonomy = Taxonomy.new params[:taxonomy]

    if @taxonomy.save
      flash.now[:notice] = 'Created!'
      render :edit
    else
      flash.now[:alert] = 'Failed!'
      render :new
    end
  end

  def update
    @taxonomy = Taxonomy.find params[:id]

    if @taxonomy.update_attributes params[:taxonomy]
      flash.now[:notice] = 'Updated!'
      render :edit
    else
      flash.now[:alert] = 'Failed!'
      render :edit
    end
  end

  def destory
    @taxonomy = Taxonomy.find params[:id]
    @taxonomy.destroy

    flash.now[:notice] = 'Deleted!'
    render :index
  end

end