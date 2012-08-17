require "bcrypt"

class Admin

  class Model
    
    def initialize
      @cache = Cache.new(CACHE)
    end
    
    def get(key)
      materialize(@cache.get(key) { DB.get(key) })
    end
    
    def save(admin)
      if admin._rev.blank?
        create(admin.email, admin.password, admin.token)
      else
        update(admin.id, admin.rev, admin.email, admin.password, admin.token)
      end
    end
    
    private
    
    def create(email, password, token)
      DB.save_doc({
        "email" => email,
        "password_hash" => password.to_s,
        "token" => token
      })
    end
    
    def update(id, rev, email, password, token)
      DB.update_doc id do |doc|
        doc["email"] = email
        doc["password_hash"] = password
        doc["auth"] = token
      end
      @cache.delete id
    end
    
    def materialize(*values)
      values.each do |row|
        Admin.new(row)
      end
    end
    
  end
  
  ID = "admin"
  
  include BCrypt

  def self.authenticate(email, password, token)
    admin = Model.get(ID)
    if !token.blank? && admin.token == token
      admin.token
    elsif admin.email == email.to_s.strip && admin.password == password.to_s
      admin.tokenize!
    else
      nil
    end
  end

  def initialize(values = nil)
    if values.is_a?(Hash)
      values.each_pair do |k,v|
        instance_variable_set("@#{k}", v)
      end
    end
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
end