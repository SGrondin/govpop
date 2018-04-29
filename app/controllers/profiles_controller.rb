class ProfilesController < ApplicationController

  def show
    render_success 200, current_user.profile.for_show
  end

  def update
    current_user.profile.assign_attributes(params.permit(*Profile::UPDATE_DIMENSIONS))
    current_user.profile.save!
    show
  end

end
