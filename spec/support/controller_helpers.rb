module ControllerHelpers
  def sign_in(user = double('user'))
    if user.nil?
      allow(controller).to receive(:current_session).and_return(nil)
      allow(controller).to receive(:current_user).and_return(nil)
    else
      session = Session.create!(user: user)
      allow(controller).to receive(:authenticate_user!).and_return(user)
      allow(controller).to receive(:current_session).and_return(session)
      allow(controller).to receive(:current_user).and_return(user)
    end

  end
end
