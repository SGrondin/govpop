class InitialTables < ActiveRecord::Migration[5.1]
  def up
    execute(<<-activerecordsql

      CREATE EXTENSION IF NOT EXISTS pgcrypto;

      CREATE TABLE users (
        id SERIAL PRIMARY KEY,
        created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
        deleted_at TIMESTAMP WITHOUT TIME ZONE,
        activated_at TIMESTAMP WITHOUT TIME ZONE,
        email TEXT NOT NULL,
        password TEXT NOT NULL,
        reset_token TEXT,
        role TEXT
      );

      CREATE UNIQUE INDEX users_email ON users USING btree (email) WHERE deleted_at IS NULL;

      CREATE TABLE sessions (
        id UUID DEFAULT GEN_RANDOM_UUID() PRIMARY KEY,
        created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
        deleted_at TIMESTAMP WITHOUT TIME ZONE,
        user_id INTEGER NOT NULL
      );

      CREATE INDEX sessions_user_id ON sessions USING btree (user_id) WHERE deleted_at IS NULL;

      CREATE TABLE profiles (
        id SERIAL PRIMARY KEY,
        created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
        deleted_at TIMESTAMP WITHOUT TIME ZONE,
        user_id INTEGER NOT NULL,
        state_id TEXT,
        gender TEXT,
        age TEXT,
        ethnicity TEXT,
        education TEXT
      );

      CREATE UNIQUE INDEX profiles_user_id ON profiles USING btree (user_id) WHERE deleted_at IS NULL;

      CREATE TABLE states (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL
      );

      CREATE TABLE questions (
        id SERIAL PRIMARY KEY,
        creator_id INTEGER NOT NULL,
        created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
        deleted_at TIMESTAMP WITHOUT TIME ZONE,
        voting_begins_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
        voting_ends_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
        title TEXT NOT NULL,
        short_text TEXT NOT NULL,
        full_text TEXT NOT NULL,
        level TEXT NOT NULL
      );

      CREATE UNIQUE INDEX questions_id ON questions USING btree (id) WHERE deleted_at IS NULL;

      CREATE TABLE representatives (
        id SERIAL PRIMARY KEY,
        first_name TEXT NOT NULL,
        last_name TEXT NOT NULL,
        state_id TEXT NOT NULL,
        level TEXT NOT NULL,
        party TEXT NOT NULL
      );

      CREATE TABLE questions_sponsors (
        id SERIAL PRIMARY KEY,
        question_id INTEGER NOT NULL,
        representative_id INTEGER NOT NULL
      );

      CREATE INDEX questions_sponsors_question_id ON questions_sponsors USING btree (question_id);
      CREATE INDEX questions_sponsors_representative_id ON questions_sponsors USING btree (representative_id);
      CREATE UNIQUE INDEX questions_sponsors_question_id_representative_id ON questions_sponsors USING btree (question_id, representative_id);

      CREATE TABLE representatives_votes (
        id TEXT PRIMARY KEY,
        question_id INTEGER NOT NULL,
        representative_id INTEGER NOT NULL,
        vote TEXT NOT NULL
      );

      CREATE INDEX representatives_votes_question_id ON representatives_votes USING btree (question_id);
      CREATE INDEX representatives_votes_representative_id ON representatives_votes USING btree (representative_id);

      CREATE TABLE users_votes (
        id TEXT PRIMARY KEY,
        created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
        question_id INTEGER NOT NULL,
        user_id INTEGER NOT NULL,
        vote TEXT NOT NULL
      );

      CREATE INDEX users_votes_question_id ON users_votes USING btree (question_id);
      CREATE INDEX users_votes_user_id ON users_votes USING btree (user_id);

    activerecordsql
    )
  end

  def down
    execute(<<-activerecordsql

      DROP TABLE users;
      DROP TABLE sessions;
      DROP TABLE profiles;
      DROP TABLE states;
      DROP TABLE questions;
      DROP TABLE representatives;
      DROP TABLE questions_sponsors;
      DROP TABLE representatives_votes;
      DROP TABLE users_votes;

    activerecordsql
    )
  end
end
