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

  protected

    def paginate_headers_for(model)
      rp = request.query_parameters

      offset = request.original_url.index('?') - 1
      url = request.original_url.slice(0..offset) unless rp.empty?
      url ||= request.original_url

      page = {}

      page[:first] = 1 if model.total_pages > 1 && !model.first_page?
      page[:last] = model.total_pages if model.total_pages > 1 && !model.last_page?
      page[:next] = model.current_page + 1 unless model.last_page?
      page[:prev] = model.current_page - 1 unless model.first_page?

      links = []

      page.each do |k,v|
        new_request_hash= rp.merge({:page => v})
        links << "<#{url}?#{new_request_hash.to_param}>;rel=\"#{k}\""
      end

      headers[:Link] = links.join ','
    end

  end

end
