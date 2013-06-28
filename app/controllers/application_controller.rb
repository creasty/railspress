class ApplicationController < ActionController::Base

  protect_from_forgery

  before_filter :set_current_user

  #  Rescue From
  #-----------------------------------------------
  rescue_from ActiveRecord::RecordNotFound do |e|
    unless Rails.configuration.consider_all_requests_local
      rescue_action_in_public e
    end
  end
  rescue_from AbstractController::ActionNotFound do |e|
    unless Rails.configuration.consider_all_requests_local
      rescue_action_in_public e
    end
  end

  #  User
  #-----------------------------------------------
  helper_method :is_admin?
  helper_method :is_current_user?

  def set_current_user
    User.current_user = current_user
  end
  def is_admin?
    user_signed_in? && current_user.try(:admin?)
  end
  def is_current_user?(id)
    user_signed_in? && current_user.id == id
  end

  #  Previous Params
  #-----------------------------------------------
  def previous_params
    flash[:params] || {}
  end
  def save_current_params
    flash[:params] = params
  end

  #  Utils
  #-----------------------------------------------
  helper_method :controller_namespace

  def controller_namespace
    path = self.class.name.split '::'
    name = controller_name.capitalize

    if path.second
      path.first.downcase
    elsif !!(Module.const_get(name) rescue false)
      name.downcase
    else
      nil
    end
  end


protected


  #  Rescue
  #-----------------------------------------------
  def rescue_action_in_public(e)
    logger.debug e
    error_404
  end


private


  #  Ajax
  #-----------------------------------------------
  def ajax_request?
    request.headers['X-Requested-With'] == 'XMLHttpRequest'
  end

  #  Error Page
  #-----------------------------------------------
  def error_page(code)
    render file: "#{Rails.root}/public/#{code}", layout: false, status: code
  end
  def error_404
    error_page 404
  end
  def error_403
    error_page 403
  end
  def error_500
    error_page 500
  end

  #  Devise
  #-----------------------------------------------
  def after_sign_in_path_for(scope)
    if request.referer.try(:include?, '/admin')
      admin_root_path
    else
      root_path
    end
  end

  def after_sign_out_path_for(scope)
    request.referer || root_path
  end

end
