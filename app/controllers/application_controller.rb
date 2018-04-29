class ApplicationController < ActionController::API
  include CanCan::ControllerAdditions

  rescue_from AuthenticationError, with: :authentication_error
  rescue_from ValidationError, with: :validation_error
  rescue_from CanCan::AccessDenied, with: :authentication_error
  rescue_from ActiveRecord::RecordInvalid, with: :ar_validation_error
  rescue_from ActionController::ParameterMissing, with: :ar_param_missing_error

  before_action :set_headers!
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:index]

  def index
    render_success 200, { hello: "world" }
  end

  private

  def render_success status, hash
    render status: status, json: hash.merge!(status: status)
  end

  def render_failure status, error
    render status: status, json: {status: status, error: error}
  end

  def set_headers!
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Methods'] = '*'
    response.headers['Access-Control-Allow-Headers'] = '*'
    response.headers['Access-Control-Max-Age'] = '31536000'
  end

  def authenticate_user!
    ssid = request.headers["HTTP_SSID"]
    raise AuthenticationError.new("Missing session header (SSID)") if ssid.nil?

    @current_session = Session.joins(:user).eager_load(:user).find_by(id: ssid)
    raise AuthenticationError.new("Must sign in") if @current_session.nil?

    @current_user = @current_session.user
  end

  def current_session
    @current_session
  end

  def current_user
    @current_user
  end

  def authentication_error error
    render_failure 401, error
  end

  def validation_error error
    render_failure 400, error
  end

  def ar_validation_error error
    render_failure 400, error.record.errors.messages
  end

  def ar_param_missing_error error
    render_failure 400, "#{error.param} must be present"
  end

end
