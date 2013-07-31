# coding: utf-8

class Admin::AdminController < Admin::ApplicationController

  def index
  end

  def activities
    render json: {
      commits: commits,
      ga: ga,
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


private


  def commits
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

  def ga
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
