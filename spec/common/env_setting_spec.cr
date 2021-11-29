require "./spec_helper"

describe EnvSetting do
  describe "::fetch" do
    it "returns the setting value corresponding to the passed environment variable string" do
      ENV["FOO"] = "BAR"
      EnvSetting.fetch("FOO").should eq "BAR"
    end

    it "returns the setting value corresponding to the passed environment variable symbol" do
      ENV["FOO"] = "BAR"
      EnvSetting.fetch(:FOO).should eq "BAR"
    end

    it "raises if the environment variable is not found" do
      expect_raises(EnvSetting::NotFoundError, "Set the UNKNOWN environment variable") do
        EnvSetting.fetch("UNKNOWN")
      end
    end

    it "can return a default value if the environment variable is not set" do
      EnvSetting.fetch("UNKNOWN", "default").should eq "default"
    end
  end
end
