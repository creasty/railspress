module Admin

  class ApplicationController < ::ApplicationController

    layout 'admin'

    before_filter :authenticate_admin!

    def authenticate_admin!
      unless user_signed_in?
        redirect_to new_user_session_path
      end
    end

  end

end
