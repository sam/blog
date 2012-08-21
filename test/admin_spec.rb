#!/usr/bin/env jruby

require_relative "helper"

describe Admin do
  describe "authentication" do
    before do
      @admin = COUCH.get("admin") rescue nil
      COUCH.delete_doc @admin if @admin
      
      COUCH.save_doc(
        "_id" => "admin",
        "email"              => "freddy@example.com",
        "password_hash"      => BCrypt::Password.create("mercury"),
        "token"              => "queen"
      )
    end
    
    after do
      temporary_admin = COUCH.get "admin" rescue nil
      COUCH.delete_doc temporary_admin if temporary_admin
      if @admin
        COUCH.save_doc(
          "_id" => "admin",
          "email"            => @admin["email"],
          "password_hash"    => @admin["password_hash"],
          "token"            => @admin["token"]
        )
      end
    end
    
    it "must fail login with a bad email/password" do
      Admin.authenticate("somebody@example.com", "to love", nil).must_be_nil
    end
    
    it "must fail login with a bad token" do
      Admin.authenticate(nil, nil, "champions").must_be_nil
    end
    
    it "must succeed login with the correct email/password" do
      Admin.authenticate("freddy@example.com", "mercury", nil).must_equal "queen"
    end
    
    it "must succeed login with the correct token" do
      Admin.authenticate(nil, nil, "queen").must_equal "queen"
    end
  end
end