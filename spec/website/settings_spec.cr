require "./spec_helper"

describe Website::Settings do
  describe "::new" do
    it "initializes settings with the expected default values" do
      settings = Website::Settings.new
      settings.google_site_verification_code.should eq "notset"
    end
  end

  describe "#google_site_verification_code" do
    it "returns the configured Googe site verification code" do
      settings = Website::Settings.new
      settings.google_site_verification_code = "test"
      settings.google_site_verification_code.should eq "test"
    end
  end

  describe "#google_site_verification_code=" do
    it "allows to configure the Google site verification code" do
      settings = Website::Settings.new
      settings.google_site_verification_code = "test"
      settings.google_site_verification_code.should eq "test"
    end
  end
end
