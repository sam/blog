class Admin
  class Db < CachedDatabase
    
    def get(key)
      materialize(@cache.get(key) { COUCH.get(key) }).first
    end
    
    private
    
    def create(admin)
      COUCH.save_doc({
        "email" => admin.email,
        "password_hash" => admin.password.to_s,
        "token" => admin.token
      })
    end
    
    def update(admin)
      COUCH.update_doc admin._id do |doc|
        doc["email"] = admin.email
        doc["password_hash"] = admin.password
        doc["token"] = admin.token
      end
      @cache.delete admin._id
    end
    
    def materialize(*values)
      values.map do |row|
        Admin.new(row)
      end
    end

  end
end