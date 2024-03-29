class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def method_missing(provider)
    if !User.omniauth_providers.index(provider).nil?
      omniauth = env["omniauth.auth"]
      logger.debug "OmniAuth Info: Params: #{params} Omni.Auth: #{omniauth}"

      if current_user
        current_user.user_tokens.find_or_create_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
        user.image = omniauth.info.image # TODO
        flash[:notice] = "Authentication successful"
        redirect_to edit_user_registration_path
      else
        authentication = UserToken.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
        if authentication
          flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => omniauth['provider']
          sign_in_and_redirect(:user, authentication.user)
        else
          unless omniauth.info.email.blank?
            user = User.find_or_initialize_by_email(:email => omniauth.info.email)
            user.image = omniauth.info.image # TODO
          else
            user = User.new
            user.image = omniauth.info.image # TODO
          end

          user.apply_omniauth(omniauth)

          if user.save
            flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => omniauth['provider']
            sign_in_and_redirect(:user, user)
          else
            session[:omniauth] = omniauth.except('extra')
            redirect_to new_user_registration_url
          end
        end
      end
    else
      render :text => "Invalid provider: #{params}"
    end
  end
end
