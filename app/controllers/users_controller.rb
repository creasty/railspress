
class UsersController < ApplicationController

  before_filter :authenticate_admin!

  def authenticate_admin!
    oauth_data = session[:oauth_data]
    unless user_signed_in?
      redirect_to new_user_session_path
    end
    unless oauth_data
      error_403
    end
  end


  def edit
    @user = User.find session[:oauth_data][:user_id]
  end

  def update
    @user = User.find session[:oauth_data][:user_id]

    if @user.update_attributes params[:user]
      flash.now[:notice] = 'Updated'
      render :edit
    else
      flash.now[:alert] = 'Failed'
      render :edit
    end
  end

  def destroy
    @user = User.find session[:oauth_data][:user_id]
    @user.destroy

    redirect_to root_path
  end

end
