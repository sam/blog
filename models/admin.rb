require "bcrypt"

class Admin

  ID = "admin"
  
  include BCrypt

  def self.authenticate(email, password, token)
    admin = Admin.new
    if !token.blank? && admin.token == token
      admin.token
    elsif admin.email == email.to_s.strip && admin.password == password.to_s
      admin.tokenize!
    else
      nil
    end
  end

  def initialize
    data = (CACHE[ID] ||= DB.get(ID).to_map)
    @email = data["email"]
    @password_hash = data["password_hash"]
    @token = data["auth"]
    @rev = data["_rev"]
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
    @token = java.util.UUID.randomUUID.to_s.freeze
    save!
    @token
  end

  def to_hash
    {
      "_id" => ID,
      "_rev" => @rev,
      "email" => @email,
      "password_hash" => password,
      "auth" => token
    }
  end

private
  def save!
    DB.update_doc ID do |doc|
      # For some insane reason you can't just call doc.merge(to_hash)!
      # Your save will silently fail...
      doc["email"] = @email
      doc["password_hash"] = password
      doc["auth"] = token
    end
    CACHE.delete ID
  end
end