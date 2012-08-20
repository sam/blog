class Admin
  class Model
    def initialize
      @cache = CacheWithDefaults.new(CACHE)
    end
    
    def get(key)
      materialize(@cache.get(key) { DB.get(key) }).first
    end
    
    def save(admin)
      admin.token # Touch the token field to ensure it's generated if not present.
      if admin._rev.blank?
        create(admin.email, admin.password, admin.token)
      else
        update(admin._id, admin._rev, admin.email, admin.password, admin.token)
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
        doc["token"] = token
        # doc["_rev"] = rev
      end
      @cache.delete id
    end
    
    def materialize(*values)
      values.map do |row|
        Admin.new(row)
      end
    end

  end
end