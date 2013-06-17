module Admin

  class ApplicationController < ::ApplicationController

    layout 'admin'

    before_filter :authenticate_admin!, except: [:login, :logout]
    before_filter :json_for_ajax_request!

    def authenticate_admin!
      if !user_signed_in?
        redirect_to admin_login_path
      elsif !current_user.try(:admin?)
        redirect_to root_path
      end
    end

    def json_for_ajax_request!
      params[:format] = 'json' if ajax_request?
    end

    def paginate_headers_for(models)
      response.headers[:total_pages] = models.total_pages.to_s
      response.headers[:per_page] = models.num_pages.to_s
      response.headers[:page] = models.current_page.to_s
    end

  end

end
