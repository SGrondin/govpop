# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180414155859) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pgcrypto"

  create_table "profiles", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.integer "user_id", null: false
    t.text "state_id"
    t.text "gender"
    t.text "age"
    t.text "ethnicity"
    t.text "education"
    t.index ["user_id"], name: "profiles_user_id", unique: true, where: "(deleted_at IS NULL)"
  end

  create_table "questions", id: :serial, force: :cascade do |t|
    t.integer "creator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.datetime "voting_begins_at", null: false
    t.datetime "voting_ends_at", null: false
    t.text "title", null: false
    t.text "short_text", null: false
    t.text "full_text", null: false
    t.text "level", null: false
    t.index ["id"], name: "questions_id", unique: true, where: "(deleted_at IS NULL)"
  end

  create_table "questions_sponsors", id: :serial, force: :cascade do |t|
    t.integer "question_id", null: false
    t.integer "representative_id", null: false
    t.index ["question_id", "representative_id"], name: "questions_sponsors_question_id_representative_id", unique: true
    t.index ["question_id"], name: "questions_sponsors_question_id"
    t.index ["representative_id"], name: "questions_sponsors_representative_id"
  end

  create_table "representatives", id: :serial, force: :cascade do |t|
    t.text "first_name", null: false
    t.text "last_name", null: false
    t.text "state_id", null: false
    t.text "level", null: false
    t.text "party", null: false
  end

  create_table "representatives_votes", id: :text, force: :cascade do |t|
    t.integer "question_id", null: false
    t.integer "representative_id", null: false
    t.text "vote", null: false
    t.index ["question_id"], name: "representatives_votes_question_id"
    t.index ["representative_id"], name: "representatives_votes_representative_id"
  end

  create_table "sessions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "sessions_user_id", where: "(deleted_at IS NULL)"
  end

  create_table "states", id: :text, force: :cascade do |t|
    t.text "name", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.datetime "activated_at"
    t.text "email", null: false
    t.text "password", null: false
    t.text "reset_token"
    t.text "role"
    t.index ["email"], name: "users_email", unique: true, where: "(deleted_at IS NULL)"
  end

  create_table "users_votes", id: :text, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "question_id", null: false
    t.integer "user_id", null: false
    t.text "vote", null: false
    t.index ["question_id"], name: "users_votes_question_id"
    t.index ["user_id"], name: "users_votes_user_id"
  end

end
