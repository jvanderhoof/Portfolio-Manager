class NewsController < ApplicationController
  before_filter :authenticate

  def index
    unless current_user
      redirect_to home_pages_path
    end
  end
end
