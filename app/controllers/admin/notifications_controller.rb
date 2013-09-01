# coding: utf-8

class Admin::NotificationsController < Admin::ApplicationController

  respond_to :json

  def index
    @notifications = User.current_user.notifications
      .order('created_at desc')
      .page(params[:page])
      .per params[:per_page]

    paginate_headers_for @notifications

    render json: [
      {
        total_entries: @notifications.total_count,
        total_pages: @notifications.total_pages,
        unread: User.current_user.notifications.unread.count
      },
      @notifications.map { |notification| notification.to_json }
    ]
  end

  def unreadCount
    render json: { num: User.current_user.notifications.unread.count }
  end

  def update
    @notification = User.current_user.notifications.find params[:id]

    if @notification.update_attributes params[:notification]
      render json: {}
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  def destroy
    @notification = User.current_user.notifications.find params[:id]
    @notification.destroy
    render json: {}, status: :ok
  end


  def dashboard
    render json: {
      commits: dashboard_commits,
      ga: dashboard_ga,
    }
  end


private


  def dashboard_commits
    @commits = {
      values: [],
      labels: [],
      tooltips: [],
    }

    oma = 29.day.ago
    post_index = 0
    comment_index = 0

    @posts = User.current_user
      .posts
      .select('date(created_at) as d, count(*) as count')
      .where('created_at >= ?', oma)
      .group('d')
      .order 'd'

    @comments = User.current_user
      .comments
      .select('date(created_at) as d, count(*) as count')
      .where('created_at >= ?', oma)
      .group('d')
      .order 'd'

    30.times do |day|
      d = oma + day.day

      @commits[:labels] << '%02d' % d.day

      post_count = 0
      comment_count = 0

      if (post_d = @posts[post_index].try :d) && d.month == post_d.month && d.day == post_d.day
        post_count = @posts[post_index].count
        post_index += 1 if @posts.length > post_index + 1
      end

      if (comment_d = @comments[comment_index].try :d) && d.month == comment_d.month && d.day == comment_d.day
        comment_count = @comments[comment_index].count
        comment_index += 1 if @comments.length > comment_index + 1
      end

      @commits[:values] << post_count + comment_count
      @commits[:tooltips] << '%d 記事<br>%d コメント' % [post_count, comment_count]
    end

    @commits
  end

  def dashboard_ga
    @pageviews = {
      values: [],
      labels: [],
    }
    @search = []

    GoogleAnalytics.login

    pageviews = GoogleAnalytics.pageview(
      start_date: 29.day.ago,
    ).results

    search = GoogleAnalytics.search(
      start_date: 29.day.ago,
      limit: 10,
      filters: {
        :organic_searches.gt => 0
      },
      sort: :pageviews.desc
    ).results

    pageviews.each do |pv|
      @pageviews[:labels] << pv.date[6..-1]
      @pageviews[:values] << pv.pageviews
    end

    search.each do |se|
      @search << {
        page_title: view_context.truncate(se.page_title, length: 60, ommission: '...'),
        page_path: se.page_path,
        pageviews: se.pageviews,
        organic: se.organic_searches,
        new_visits: '%.2f%' % se.percent_new_visits.to_f,
        exit_rate: '%.2f%' % se.exit_rate.to_f,
        source: se.source,
      }
    end

    {
      pageviews: @pageviews,
      search: @search,
    }
  end

end
