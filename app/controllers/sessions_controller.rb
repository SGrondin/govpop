class SessionsController < ApplicationController

  skip_before_action :authenticate_user!, only: [:create]

  def show
    render_success 200, { ssid: @current_session.id }
  end

  def create
    user = User.from_email params.require(:email)

    session = user.login! params.require(:password)
    render_success 200, { ssid: session.id }
  end

  def destroy
    current_session.destroy!
    render_success 200, {}
  end

end
