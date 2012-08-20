require "bcrypt"
require "models/admin/db"

class Admin
  include Model
  
  ID = "admin"
  
  include BCrypt

  def self.authenticate(email, password, token)
    admin = self.db.get(ID)
    if !token.blank? && admin.token == token
      admin.token
    elsif admin.email == email.to_s.strip && admin.password == password.to_s
      self.db.save(admin)
      admin.token # Return the token so that it can be added to the Session.
    else
      nil
    end
  end 

  def password
    @password ||= Password.new(@password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
  end

  def token
    @token ||= java.util.UUID.randomUUID.to_s.freeze
  end
end