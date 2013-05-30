class PagesController < ApplicationController

  def index
    @page_title = { after: 'personal project for study Rails' }
  end

  def show
    @page = Page.find params[:id]
  rescue ActiveRecord::RecordNotFound
    path = "#{params[:id]}/#{params[:id2]}/#{params[:id3]}"
    path.gsub!(/\/+/, '/')
    path.gsub!(/\.+/, '')
    path.chomp!('/')

    begin
      render "statics/#{path}"
    rescue
      error_404
    end
  end

end
