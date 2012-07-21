class ApplicationController < ActionController::Base
  protect_from_forgery

  layout :layout_by_resource

  protected

  def layout_by_resource
    if user_signed_in?
      "application"
    else
      "welcome"
    end
  end
end
