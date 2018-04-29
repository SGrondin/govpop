class User < ApplicationRecord

  PW_LENGTH = (10..100)

  has_many :session, dependent: :destroy
  has_one :profile, dependent: :destroy

  acts_as_paranoid

  SUPERADMIN = 'SUPERADMIN'
  ADMIN = 'ADMIN'
  VALID_ROLES = [SUPERADMIN, ADMIN]

  validates_inclusion_of :role, in: VALID_ROLES, allow_blank: true
  validates :email, uniqueness: true, allow_blank: false
  validates_presence_of :profile, if: -> { activated_at.present? }

  def superadmin?
    role == SUPERADMIN
  end

  def admin?
    role == ADMIN
  end

  def active?
    activated_at.present?
  end

  def self.build email, token: nil
    token ||= SecureRandom.hex(24)
    puts "*** TOKEN: #{token}" if Rails.env.development?
    new({
      email: email,
      password: BCrypt::Password.create(SecureRandom.base64(24)),
      reset_token: BCrypt::Password.create(token)
    })
  end

  def self.from_email received_email
    user = User.find_by(email: received_email)
    raise AuthenticationError.new("Invalid email") if user.nil?
    user
  end

  def forgot_password
    token = SecureRandom.hex(24)
    puts "*** TOKEN: #{token}" if Rails.env.development?
    assign_attributes({
      reset_token: BCrypt::Password.create(token)
    })
  end

  def change_password current_password, new_password
    validate_current_password current_password
    validate_new_password new_password

    assign_attributes({
      password: BCrypt::Password.create(new_password),
      reset_token: nil
    })
  end

  def change_password_by_token received_token, new_password
    validate_token received_token
    validate_new_password new_password

    assign_attributes({
      password: BCrypt::Password.create(new_password),
      reset_token: nil
    })
  end

  def login! received_password
    validate_current_password received_password
    Session.create!(user: self)
  end

  def logout_all!
    Session.where(user: self).destroy_all
  end

  private

  def validate_token received_token
    raise AuthenticationError.new("Invalid token") unless BCrypt::Password.new(reset_token).is_password? received_token
    true
  end

  def validate_current_password received_password
    raise AuthenticationError.new("Invalid password") unless BCrypt::Password.new(password).is_password? received_password
    true
  end

  def validate_new_password new_password
    raise ValidationError.new("Password must be between #{PW_LENGTH.min} and #{PW_LENGTH.max} characters") unless PW_LENGTH.include?(new_password.size)
    true
  end

end
