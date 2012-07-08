class HomeController < ApplicationController
  def index
    if user_signed_in?
      redirect_to "/#{current_user.name}"
    end
  end
end
