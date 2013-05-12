
class UsersController < ApplicationController

  before_filter :authenticate_admin!

  def authenticate_admin!
    unless user_signed_in?
      redirect_to new_user_session_path
    end
  end


  def edit
    @user = User.find current_user
  end

  def update
    @user = User.find current_user

    if @user.update_attributes params[:user]
      flash.now[:notice] = 'Updated'
      render :edit
    else
      flash.now[:alert] = 'Failed'
      render :edit
    end
  end

  def destroy
    @user = User.find current_user
    @user.destroy

    redirect_to root_path
  end

end
