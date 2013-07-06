
class Admin::AdminController < Admin::ApplicationController

  def index
    GoogleAnalytics.login
    @pageviews = GoogleAnalytics.pageview(
      start_date: 1.month.ago,
      # limit: 10,
      sort: 'pageviews.desc',
    ).results
  end

  def login
    if is_admin?
      redirect_to admin_root_path
    end
  end

  def logout
    sign_out current_user
    redirect_to admin_login_path
  end

end
