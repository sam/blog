require "json"
require "bcrypt"
require "uuid"

class Admin

  include BCrypt

  def self.authenticate(email, password, token)
    admin = Admin.new
    if admin.token == token
      admin.token
    elsif admin.email == email.strip && admin.password == password
      admin.tokenize!
    else
      nil
    end
  end

  def initialize
    data = JSON::parse(config.redis.get "admin")
    @email = data["email"]
    @password_hash = data["password_hash"]
    @token = data["token"]
  end

  attr_reader :email

  def password
    @password ||= Password.new(@password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    save!
    @password
  end

  def token
    @token ||= tokenize!
  end

  def tokenize!
    @token = UUID.new.generate
    save!
    @token
  end

  def to_hash
    {
      "email" => @email,
      "password_hash" => password,
      "token" => token
    }
  end

  def to_json
    to_hash.to_json
  end

private
  def save!
    config.redis.set "admin", to_json
  end
end