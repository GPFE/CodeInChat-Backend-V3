module Authentication
  extend ActiveSupport::Concern
  included do
    before_action :require_authentication
    after_action :refresh_session
  end
  private

  def require_authentication
    resume_session || render_unauthorized
  end

  def resume_session
    token = cookies.encrypted[:session_token]
    Current.session = Session.find_by(token: token)
    p "cookie"
    p cookies.to_h
    p "setting current modeeeeeeeeeeeeeeeeeeeeeeeellllllll"
    p Current.session
    p "initial cooooooooooookieeeeeeeeeeeeeeee"
    p cookies.encrypted[:session_token]
    Current.session
  end

  def refresh_session
    if Current.session
      Current.session.regenerate_token!

      cookies.encrypted[:session_token] = {
        value: Current.session.token,
        httponly: true,
        secure: Rails.env.production?, # to-do improve this
        expires: 2.weeks.from_now
      }
    end
  end
  def render_unauthorized
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end