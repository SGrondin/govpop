require 'rails_helper'

describe QuestionsController, type: :controller do
  before do
    @user = create :user
    sign_in @user
  end

  describe "#index" do
    it "returns the last 5 questions" do
      q1 = create :question, title: "AAA"
      q2 = create :question, title: "BBB"
      q3 = create :question, title: "CCC"
      q4 = create :question, title: "DDD"
      q5 = create :question, title: "EEE"
      q6 = create :question, title: "FFF"
      q7 = create :question, title: "GGG"

      response = get :index
      expect(response).to have_status 200
      expect(response).to match_schema "questions_index"

      parsed = JSON.parse response.body
      expect(parsed['questions'].size).to eq 5
      expect(parsed['questions'].map{|q| q['title']}).to eq ['GGG', 'FFF', 'EEE', 'DDD', 'CCC']
    end
  end

  describe "#show" do
    it "returns the data for a specific question" do
      q1 = create :question, short_text: "AAA"
      q2 = create :question, short_text: "BBB"

      response = get :show, as: :json, params: {
        id: q1.id
      }
      expect(response).to have_status 200
      expect(response).to match_schema "questions_show"

      parsed = JSON.parse response.body
      expect(parsed['short_text']).to eq 'AAA'
    end
  end

  describe "#create" do
    it "lets admins make a new question" do
      admin = create :user, :admin
      sign_in admin

      response = post :create, as: :json, params: {
        voting_begins_at: (Time.zone.now + 1.hour),
        voting_ends_at: (Time.zone.now + 3.days),
        title: "Hello",
        short_text: "bl",
        full_text: "blah",
        sponsors: [50, 51]
      }
      expect(response).to have_status 200
      expect(response).to match_schema "questions_show"

      parsed = JSON.parse response.body
      expect(parsed['sponsors'].pluck('id')).to eq [50, 51]
    end

    it "does not allow normal users" do
      response = post :create, as: :json, params: {
        short_text: "Hello"
      }
      expect(response).to have_status 401
      expect(response).to have_error "You are not authorized to access this page."
    end
  end

  describe "#update" do
    it "lets admins edit a question" do
      admin = create :user, :admin
      sign_in admin
      q1 = create :question, short_text: "hahaha"

      response = put :update, as: :json, params: {
        id: q1.id,
        short_text: "hohoho",
        sponsors: [50, 55]
      }
      expect(response).to have_status 200
      expect(response).to match_schema "questions_show"

      parsed = JSON.parse response.body
      expect(parsed['short_text']).to eq "hohoho"
      expect(parsed['sponsors'].pluck('id')).to eq [50, 55]
    end

    it "does not allow normal users" do
      q1 = create :question

      response = put :update, as: :json, params: {
        id: q1.id,
        short_text: "Hello"
      }
      expect(response).to have_status 401
      expect(response).to have_error "You are not authorized to access this page."
    end
  end
end
