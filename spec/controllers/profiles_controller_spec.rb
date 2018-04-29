require 'rails_helper'

describe ProfilesController, type: :controller do
  describe "#show" do
    it "returns current profile" do
      user = create :user, profile: (build :profile, gender: "F")
      sign_in user

      response = get :show
      expect(response).to have_status 200
      expect(response).to match_schema "profiles_show"

      parsed = JSON.parse response.body
      expect(parsed['state_id']).to eq "NY"
      expect(parsed['gender']).to eq "F"
    end
  end

  describe "#update" do
    it "updates current profile" do
      user = create :user, profile: (build :profile, gender: "F")
      expect(user.profile.gender).to eq "F"
      expect(user.profile.age).to eq "19-35"
      expect(user.profile.education).to eq "B"
      sign_in user

      response = put :update, as: :json, params: {
        gender: "O",
        age: "66+",
        education: "G"
      }
      expect(response).to have_status 200
      expect(response).to match_schema "profiles_update"

      parsed = JSON.parse response.body
      expect(parsed['state_id']).to eq "NY"
      expect(parsed['gender']).to eq "O"
      expect(parsed['age']).to eq "66+"
      expect(parsed['education']).to eq "G"

      user.reload
      expect(user.profile.state_id).to eq "NY"
      expect(user.profile.gender).to eq "O"
      expect(user.profile.age).to eq "66+"
      expect(user.profile.education).to eq "G"
    end
  end
end
