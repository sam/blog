require "bcrypt"
require "models/admin/model"

class Admin
  
  include HashInitialization
  
  ID = "admin"
  
  include BCrypt
  
  def self.model
    @model ||= Model.new
  end
  
  def self.model=(value)
    @model = value
  end

  def self.authenticate(email, password, token)
    admin = self.model.get(ID)
    if !token.blank? && admin.token == token
      admin.token
    elsif admin.email == email.to_s.strip && admin.password == password.to_s
      self.model.save(admin)
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