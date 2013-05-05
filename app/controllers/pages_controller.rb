class PagesController < ApplicationController

  def index
    @page_title = { after: 'personal project for study Rails' }
  end

  def show
    @page_title = { depth: nil }
  end

end
