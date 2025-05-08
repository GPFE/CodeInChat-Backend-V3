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
    token = request.headers['Authorization']&.split(' ')&.last
    Current.session = Session.find_by(token: token)
    p Current.session
    Current.session
  end
  def refresh_session
    if Current.session
      Current.session.regenerate_token!
      response.set_header('Authorization', "Bearer #{Current.session.token}")
    end
  end
  def render_unauthorized
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end