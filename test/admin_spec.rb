#!/usr/bin/env jruby

require_relative "helper"

describe Admin do
  describe "authentication" do
    it "must fail login with a bad username/password" do
      Admin.authenticate("somebody", "to love", nil).must_be_nil
    end
  end
end