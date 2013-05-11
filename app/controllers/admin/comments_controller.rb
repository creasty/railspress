
class Admin::CommentsController < Admin::ApplicationController

  def index
    @comments = Comment.order 'created_at DESC'
  end

end
