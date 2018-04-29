class UsersController < ApplicationController

  skip_before_action :authenticate_user!, only: [:create, :activate, :forgot_password, :reset_password]

  def create
    User.build(params.require(:email)).save!
    render_success 200, {}
  end

  def activate
    ActiveRecord::Base.transaction do
      user = User.from_email params.require(:email)
      raise ValidationError.new("User already activated") if user.active?

      user.change_password_by_token params.require(:token), params.require(:password)
      user.activated_at = Time.zone.now
      profile = Profile.new(user: user)
      profile.assign_attributes(params.require(:profile).permit(*Profile::UPDATE_DIMENSIONS))
      profile.save!
      user.save!

      session = user.login! params.require(:password)
      render_success 200, { ssid: session.id }
    end
  end

  def change_password
    ActiveRecord::Base.transaction do
      current_user.change_password params.require(:password), params.require(:new_password)
      current_user.logout_all!
      current_user.save!

      session = current_user.login! params.require(:new_password)
      render_success 200, { ssid: session.id }
    end
  end

  def forgot_password
    user = User.from_email params.require(:email)

    user.forgot_password
    user.save!

    render_success 200, {}
  end

  def reset_password
    ActiveRecord::Base.transaction do
      user = User.from_email params.require(:email)

      user.change_password_by_token params.require(:token), params.require(:new_password)
      user.logout_all!
      user.save!

      session = user.login! params.require(:new_password)
      render_success 200, { ssid: session.id }
    end
  end

  def show
    render_success 200, { email: current_user.email }
  end

end
