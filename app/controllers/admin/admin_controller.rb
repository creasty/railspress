
class Admin::AdminController < Admin::ApplicationController

  def index
    GoogleAnalytics.login

  end

  def google_analytics
    GoogleAnalytics.login

    pageviews = GoogleAnalytics.pageview(
      start_date: 1.month.ago,
    ).results

    search = GoogleAnalytics.search(
      start_date: 1.month.ago,
      limit: 10,
      filters: {
        :organic_searches.gt => 0
      },
      sort: :pageviews.desc
    ).results

    @pageviews = {
      values: [],
      labels: [],
    }
    pageviews.each do |pv|
      @pageviews[:labels] << pv.date[6..-1]
      @pageviews[:values] << pv.pageviews
    end

    @search = []
    search.each do |se|
      @search << {
        page_title: view_context.truncate(se.page_title, length: 40, ommission: '...'),
        page_path: se.page_path,
        pageviews: se.pageviews,
        organic: se.organic_searches,
        new_visits: '%.2f%' % se.percent_new_visits.to_f,
        exit_rate: '%.2f%' % se.exit_rate.to_f,
        source: se.source,
      }
    end

    render json: {
      pageviews: @pageviews,
      search: @search,
    }
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
