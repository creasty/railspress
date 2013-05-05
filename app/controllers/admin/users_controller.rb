
class Admin::UsersController < Admin::ApplicationController

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find params[:id]
  end

  def create
    @user = User.new params[:user]

    if @user.save
      flash.now[:notice] = 'Created!'
      render :edit
    else
      flash.now[:alert] = 'Failed!'
      render :new
    end

  end

  def update
    @user = User.find params[:id]

    params[:user].delete_if { |_, v| v.blank? }

    @user.attributes = params[:user]

    if @user.save
      flash.now[:notice] = 'Updated!'
      render :edit
    else
      flash.now[:alert] = 'Failed!'
      render :edit
    end
  end

  def destroy

    @user = User.find params[:id]
    @user.destroy

    render :index

  end

end
