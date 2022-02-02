class OauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :find_auth, :find_user, only: %i[github vkontakte]

  def github
    common_login_process 'GitHub'
  end

  def vkontakte
    @auth = request.env['omniauth.auth']
    if @auth && !@user&.email_confirmed?(@auth)
      redirect_to new_authorization_path(uid: @auth.uid, provider: @auth.provider)
    else
      common_login_process 'Vkontakte'
    end
  end

  private

  def find_auth
    @auth = request.env['omniauth.auth']
  end

  def find_user
    @user = User.find_for_oauth(@auth)
  end

  def common_login_process(kind)
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
