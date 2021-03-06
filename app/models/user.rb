class User < ApplicationRecord
  # has_secure_password does a fex things for us
  # automatically adds 'password' and 'password_confirmation' attribute
  # accessors -> we need them in memory but not in the db
  # - it autmoatically adds a presence validator on the password
  # - it automatically adds the confirmtion validator if you add a
  #   password confirmation field-> optional to users
  # when password is provided has_secure_password will generate a salt and
  # will generate a digest of  the password + salt and it will store it in the
  # 'password_digest' field
  # - it gives us a handy method called `authentciate` that will help us check
  #   if the password is correct
  # http://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html#method-i-has_secure_password
# regex are objects in ruby used to match strings -> http://rubular.com/

  has_secure_password

  has_many :questions, dependent: :nullify

  before_validation :downcase_email

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  # in console -> VALID_EMAIL_REGEX.match('abc@abc.com') ->returns match data
  validates :email, presence: true, uniqueness: true, format: VALID_EMAIL_REGEX

  def full_name
    "#{first_name} #{last_name}".strip.titleize
  end

  private

  def downcase_email
    self.email&.downcase!
  end
end
