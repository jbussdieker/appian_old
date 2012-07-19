class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    if !User.omniauth_providers.index(provider).nil?
      omniauth = env["omniauth.auth"]
      render :text => "ASDF #{params} OMNI: #{omniauth}"
    else
      render :text => "NOPS ASDF #{params}"
    end
  end
end
