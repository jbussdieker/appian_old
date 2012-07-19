class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def method_missing(provider)
    if !User.omniauth_providers.index(provider).nil?
      omniauth = env["omniauth.auth"]

      if current_user
        current_user.user_tokens.find_or_create_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
        flash[:notice] = "Authentication successful"
        redirect_to edit_user_registration_path
      else
        authentication = UserToken.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
        if authentication
          flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => omniauth['provider']
          sign_in_and_redirect(:user, authentication.user)
        else
          render :text => "Unknown user: #{params} OMNI: #{omniauth}"
        end
      end
    else
      render :text => "Invalid provider: #{params}"
    end
  end
end
