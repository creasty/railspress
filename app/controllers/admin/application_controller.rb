module Admin

  class ApplicationController < ::ApplicationController

    layout 'admin'

    before_filter :authenticate_admin!

    def authenticate_admin!
      if !user_signed_in?
        redirect_to new_user_session_path
      elsif !current_user.try(:admin?)
        error_403
        # redirect_to root_path
      end
    end

  end

end
