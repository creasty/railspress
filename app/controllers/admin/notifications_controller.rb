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

end
