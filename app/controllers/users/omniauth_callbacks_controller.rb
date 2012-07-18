class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    render :text => "ASDF #{params}"
  end
end
