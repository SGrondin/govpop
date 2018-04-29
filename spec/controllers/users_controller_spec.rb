require 'rails_helper'

describe UsersController, type: :controller do
  describe "#create" do
    it "creates a new user" do
      email = "newuser@govpop.com"
      expect(User.count).to eq 1
      response = post :create, as: :json, params: {
        email: email
      }
      expect(response).to have_status 200
      expect(User.count).to eq 2
      expect(User.last.email).to eq email
    end
  end

  describe "#activate" do
    it "activates a new user" do
      user = create :user, :inactive

      response = post :activate, as: :json, params: {
        email: user.email,
        token: "factory-token",
        password: "supersecure",
        profile: {
          state_id: "NY",
          gender: "M"
        }
      }
      expect(response).to have_status 200
      expect(response).to match_schema "ssid"
      expect(response).to match_schema "users_activate"

      user.reload
      expect(user.send(:validate_current_password, "supersecure")).to eq true
      expect(user.session.size).to eq 1
      expect(user.activated_at).to_not be_nil
      expect(user.profile.state.id).to eq "NY"
      expect(user.profile.gender).to eq "M"
    end

    it "checks activation" do
      user = create :user

      response = post :activate, as: :json, params: {
        email: user.email,
        token: "factory-token",
        password: "supersecure",
        profile: { state_id: "NY" }
      }
      expect(response).to have_status 400
      expect(response).to have_error "User already activated"
    end

    it "checks email" do
      user = create :user, :inactive

      response = post :activate, as: :json, params: {
        email: "bad-email",
        token: "factory-token",
        password: "supersecure",
        profile: { state_id: "NY" }
      }
      expect(response).to have_status 401
      expect(response).to have_error "Invalid email"
    end

    it "checks token" do
      user = create :user, :inactive

      response = post :activate, as: :json, params: {
        email: user.email,
        token: "invalid-token",
        password: "supersecure",
        profile: { state_id: "NY" }
      }
      expect(response).to have_status 401
      expect(response).to have_error "Invalid token"
    end

    it "checks password" do
      user = create :user, :inactive

      response = post :activate, as: :json, params: {
        email: user.email,
        token: "factory-token",
        password: "blah",
        profile: { state_id: "NY" }
      }
      expect(response).to have_status 400
      expect(response).to have_error "Password must be between 10 and 100 characters"
    end
  end

  describe "#change_password" do
    it "changes password" do
      user = create :user
      sign_in user
      session = user.session.first

      response = post :change_password, as: :json, params: {
        password: "supersecret",
        new_password: "newsuperpass"
      }
      expect(response).to have_status 200
      expect(response).to match_schema "ssid"
      expect(response).to match_schema "users_change_password"

      user.reload
      expect(user.send(:validate_current_password, "newsuperpass")).to eq true
      expect(user.session.first).to_not eq session
    end

    it "checks session" do
      user = create :user

      response = post :change_password, as: :json, params: {
        password: "supersecret",
        new_password: "newsuperpass"
      }
      expect(response).to have_status 401
      expect(response).to have_error "Missing session header (SSID)"
    end

    it "checks old password" do
      user = create :user
      sign_in user

      response = post :change_password, as: :json, params: {
        password: "invalid",
        new_password: "newsuperpass"
      }
      expect(response).to have_status 401
      expect(response).to have_error "Invalid password"
    end

    it "checks new password" do
      user = create :user
      sign_in user

      response = post :change_password, as: :json, params: {
        password: "supersecret",
        new_password: "blah"
      }
      expect(response).to have_status 400
      expect(response).to have_error "Password must be between 10 and 100 characters"
    end
  end

  describe "#forgot_password" do
    it "sets a new token" do
      user = create :user
      expect(user.reset_token).to be_nil

      response = post :forgot_password, as: :json, params: {
        email: user.email
      }
      expect(response).to have_status 200

      user.reload
      expect(user.reset_token).to_not be_nil
    end

    it "checks email" do
      user = create :user

      response = post :forgot_password, as: :json, params: {
        email: "bad-email"
      }
      expect(response).to have_status 401
      expect(response).to have_error "Invalid email"
    end
  end

  describe "#reset_password" do
    it "resets password using token" do
      user = create :user, reset_token: BCrypt::Password.create("some-token")

      response = post :reset_password, as: :json, params: {
        email: user.email,
        token: "some-token",
        new_password: "newsuperpass"
      }
      expect(response).to have_status 200
      expect(response).to match_schema "ssid"
      expect(response).to match_schema "users_reset_password"

      user.reload
      expect(user.reset_token).to be_nil
      expect(user.send(:validate_current_password, "newsuperpass")).to eq true
      expect(user.session.exists?).to eq true
    end

    it "checks email" do
      user = create :user, reset_token: BCrypt::Password.create("some-token")

      response = post :reset_password, as: :json, params: {
        email: "bad-email",
        token: "some-token",
        new_password: "newsuperpass"
      }
      expect(response).to have_status 401
      expect(response).to have_error "Invalid email"
    end

    it "checks token" do
      user = create :user, reset_token: BCrypt::Password.create("some-token")

      response = post :reset_password, as: :json, params: {
        email: user.email,
        token: "bad-token",
        new_password: "newsuperpass"
      }
      expect(response).to have_status 401
      expect(response).to have_error "Invalid token"
    end

    it "checks new password" do
      user = create :user, reset_token: BCrypt::Password.create("some-token")

      response = post :reset_password, as: :json, params: {
        email: user.email,
        token: "some-token",
        new_password: "short"
      }
      expect(response).to have_status 400
      expect(response).to have_error "Password must be between 10 and 100 characters"
    end
  end


end
