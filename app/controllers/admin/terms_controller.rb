
class Admin::TermsController < Admin::ApplicationController

  def index
    @terms = Term.includes(:term_rels, :taxonomy).all
  end

  def search
    @terms = Term.where('terms.name like ?', "%#{params[:q]}%")

    respond_to do |format|
      format.html { render }
      format.text { render text: @terms.map { |t| t.name }.join("\n") }
    end
  end

  def new
    @term = Term.new
  end

  def edit
    @term = Term.find params[:id]
  end

  def create
    @term = Term.new params[:term]

    if @term.save
      flash.now[:notice] = 'Created!'
      render :edit
    else
      flash.now[:alert] = 'Failed!'
      render :new
    end
  end

  def update
    @term = Term.find params[:id]

    if @term.update_attributes params[:term]
      flash.now[:notice] = 'Updated!'
    else
      flash.now[:alert] = 'Failed!'
    end

    render :edit
  end

  def destroy
    @term = Term.find params[:id]
    @term.destroy
    render :index
  end

end