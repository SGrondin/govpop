require 'rails_helper'

describe SessionsController, type: :controller do
  describe "#create" do
    it "creates a new session" do
      user = create :user
      expect(user.session.exists?).to eq false

      response = post :create, as: :json, params: {
        email: user.email,
        password: "supersecret"
      }
      expect(response).to have_status 200
      expect(response).to match_schema "ssid"
      expect(response).to match_schema "sessions_create"

      user.reload
      expect(user.session.exists?).to eq true
    end

    it "checks email" do
      user = create :user

      response = post :create, as: :json, params: {
        email: "invalid",
        password: "supersecret"
      }
      expect(response).to have_status 401
      expect(response).to have_error "Invalid email"
    end

    it "checks password" do
      user = create :user

      response = post :create, as: :json, params: {
        email: user.email,
        password: "bad"
      }
      expect(response).to have_status 401
      expect(response).to have_error "Invalid password"
    end
  end

  describe "#destroy" do
    it "deletes existing session" do
      user = create :user
      sign_in user

      response = delete :destroy
      expect(response).to have_status 200
    end

    it "checks login" do
      user = create :user

      response = delete :destroy
      expect(response).to have_status 401
      expect(response).to have_error "Missing session header (SSID)"
    end
  end
end
