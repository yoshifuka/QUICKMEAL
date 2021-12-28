class PagesController < ApplicationController
  before_action :authenticate_user!, except: [:home]
  def home
    if user_signed_in?
      @feed_items = current_user.feed.page(params[:page]).per(5)
      @record = Record.new
    end
  end
end
