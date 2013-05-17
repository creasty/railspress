module Admin

  class ApplicationController < ::ApplicationController

    layout 'admin'

    before_filter :authenticate_admin!, except: [:login, :logout]

    def authenticate_admin!
      if !user_signed_in?
        redirect_to admin_login_path
      elsif !current_user.try(:admin?)
        redirect_to root_path
      end
    end

  end

end
