class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github(provider)
    render :text => "ASDF #{provider} #{params}"
  end
end
