
class Admin::CommentsController < Admin::ApplicationController

  def index
    @comments = Comment
      .group('post_id')
      .order('created_at DESC')
      .includes :post

  end

end
